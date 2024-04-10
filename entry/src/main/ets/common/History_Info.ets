import ArrayList from '@ohos.util.ArrayList';
import FarmBean from '../common/bean/FarmBean';
import UIAbility from '@ohos.app.ability.UIAbility';
import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import systemDateTime from '@ohos.systemDateTime';
import ability_featureAbility from '@ohos.ability.featureAbility';
import DistributedUtil from '../DB/DistributedUtil';
import LinkedList from '@ohos.util.LinkedList';
/*
 * 01 03 00 00 00 01 84 0A 读取含水量
01 03 00 01 00 01 D5 CA 只读取温度
01 03 00 02 00 01 25 CA 读取电导率
01 03 00 03 00 01 74 0A 读取PH
01 03 00 04 00 01 C5 CB 读取K
01 03 00 05 00 01 94 0B 读取P
01 03 00 06 00 01 64 0B 读取K
01 03 00 07 00 01 35 CB 读取盐度
01 03 00 08 00 01 05 C8 读取总溶解固体

01 03 02 00 2A 39 9B 响应
00 2A 读取含水量 扩大十倍
01 03 02 00 F9 78 06
00 F9 读取温度 扩大十倍
01 03 02 00 00 B8 44
00 00 读取电导值
01 03 02 00 1E 38 4C
00 1E 读取PH值 扩大十倍
01 03 02 00 00 B8 44
读取氮磷钾
 * */
export default class History_Info{
  fieldId : number;
  name: string;
  history_humidity: ArrayList<number> = new ArrayList<number>();
  history_temperature: ArrayList<number> =  new ArrayList<number>();
  history_conductivity: ArrayList<number> =  new ArrayList<number>();
  history_PH: ArrayList<number> =  new ArrayList<number>();
  history_co2: ArrayList<number> =  new ArrayList<number>();
  history_lumination: ArrayList<number> =  new ArrayList<number>();
  history_soilHumidity: ArrayList<number> =  new ArrayList<number>();
  history_NPK : ArrayList<ArrayList<number>> = new ArrayList<ArrayList<number>>();
  sensor_IP: string;
  sensor_port: number;
  time_axis : ArrayList<Date> =new ArrayList<Date>();

  constructor(fieldId:number,
              name:string,
              sensor_IP:string,
              sensor_port:number) {
    this.fieldId = fieldId;
    this.name = name;
    this.history_humidity = new ArrayList<number>();
    this.history_temperature = new ArrayList<number>();
    this.history_conductivity = new ArrayList<number>();
    this.history_PH = new ArrayList<number>();
    this.history_co2 = new ArrayList<number>();
    this.history_lumination = new ArrayList<number>();
    this.history_soilHumidity = new ArrayList<number>();
    this.history_NPK = new ArrayList<ArrayList<number>>();
    this.sensor_IP = sensor_IP;
    this.sensor_port = sensor_port;
    this.time_axis = new ArrayList<Date>();
  }

  // ----------------将farmBean转化为一个历史数据------------------//
    async FarmBean_to_History(farm_bean:FarmBean){
      try {
        this.history_temperature.add(farm_bean.temperature);
        this.history_humidity.add(farm_bean.humidity)
        this.history_conductivity.add(farm_bean.conductivity);
        this.history_PH.add(farm_bean.PH);
        this.history_co2.add(farm_bean.co2);
        this.history_lumination.add(farm_bean.lumination);
        this.history_soilHumidity.add(farm_bean.soilHumidity);
        this.history_NPK.add(farm_bean.NPK);
        const time = await systemDateTime.getDate();
        this.time_axis.add(time)
        console.info(time.toString())
        console.info('history_info changed now length is '+this.history_temperature.length.toString());


        //this.time_axis.add(time);
      }catch (e){
        console.info(e)
      }

  }
  // ----------------将farmBean转化为一个历史数据------------------//

  // --------------------json转化部分（finished)------------------//
  to_JSON():string{
    var temp ={
      fieldId:this.fieldId,
      name: this.name,
      history_temperature: this.history_temperature,
      history_humidity: this.history_humidity,
      history_co2: this.history_co2,
      history_lumination: this.history_lumination,
      history_soilHumidity: this.history_soilHumidity,
      sensor_IP : this.sensor_IP,
      sensor_port: this.sensor_port,
      history_NPK: this.history_NPK,
      history_PH: this.history_PH,
      history_conductivity : this.history_conductivity,
      time_axis: this.time_axis
    }
    return JSON.stringify(temp);
  }

  //给一个JSON对象，返回一个FarmBean
  static JSON_to(message):History_Info{
    var temp:History_Info = new History_Info(
      message.fieldId,
      message.name,
      message.sensor_IP,
      message.sensor_port
    );
    temp.history_humidity = History_Info.to_arraylist(message.history_humidity);
    //console.info('load len of '+temp.history_temperature.length);
    temp.history_temperature = History_Info.to_arraylist(message.hishumory_temperature);
    temp.history_conductivity = History_Info.to_arraylist(message.history_conductivity);
    temp.history_PH = History_Info.to_arraylist(message.history_PH);
    temp.history_co2 = History_Info.to_arraylist(message.history_co2);
    temp.history_lumination = History_Info.to_arraylist(message.history_lumination);
    temp.history_soilHumidity = History_Info.to_arraylist(message.history_soilHumidity);
    console.info('json to history_info');

    //temp.history_NPK = History_Info.to_arraylist(message.history_NPK).map(Object.values);

    return temp;
  }

  // --------------------json转化部分（finished)------------------//
  // --------------------数据库操作部分（finished)------------------//
  save_db(){
    // id+4e5为数据库名称
    DistributedUtil.putStoreData((this.fieldId+4e5).toString(),this.to_JSON());
    console.info('successfully save in db')
  }

  static async read_db(id: string): Promise<History_Info> {
    try {
      let ID = parseInt(id, 10) + 4e5

      const res = await DistributedUtil.getStoreData(ID.toString());
      const jsonObject = JSON.parse(JSON.parse(JSON.stringify(res)));
      console.log('history===获取数据库中的历史数据====read history from db');
      let temp1 = History_Info.to_arraylist(jsonObject.history_temperature)
      //console.info("temp")
     // console.info('2leng'+ History_Info.to_arraylist(Object.values(jsonObject.history_temperature))[0])
      let temp:History_Info = new History_Info(jsonObject.fieldId,
        jsonObject.name,
        jsonObject.sensor_IP,
        jsonObject.sensor_port)
      temp.history_temperature = History_Info.to_arraylist(jsonObject.history_temperature);
      temp.history_humidity = History_Info.to_arraylist(jsonObject.history_humidity)
      temp.history_conductivity = History_Info.to_arraylist(jsonObject.history_conductivity)
      temp.history_PH = History_Info.to_arraylist(jsonObject.history_PH)
      temp.history_co2 = History_Info.to_arraylist(jsonObject.history_co2)
      temp.history_lumination = History_Info.to_arraylist(jsonObject.history_lumination)
      temp.history_soilHumidity = History_Info.to_arraylist(jsonObject.history_soilHumidity)
      temp.history_NPK = History_Info.to_arr_arr(jsonObject.history_NPK)
      temp.time_axis = History_Info.to_arr_time(jsonObject.time_axis)
      //console.info(JSON.stringify(temp))
      console.info("successfully read history")
      return temp;
    } catch (error) {
      console.error('Error reading from database:', error);
      return null;
    }
  }

  static delete_db(id:string):boolean{
    try {
      let ID = parseInt(id, 10) + 4e5
      DistributedUtil.deleteStoreData(ID.toString());
      console.info("delete " + id + 'history database');
      return true;
    }catch (e){
      console.info('error delete'+ id + 'history database and error is'+e);
      return false;
    }
  }

  // --------------------数据库操作部分（finished)------------------//

  // --------------------数组装配部分 -------------------------//
  static  to_arraylist(message):ArrayList<number>{
    let array = new ArrayList<number>();
    if(!Object.keys(message)) return array;
    for(let index of Object.keys(message)){
      array.add(message[index]);
    }
    //console.info("begin= "+array[0].toString()+"length = "+array.length)
    return array;
  }

  static  to_arr_arr(message):ArrayList<ArrayList<number>>{
    let array = new ArrayList<ArrayList<number>>();
    for(let index of Object.keys(message)){
      let temp  = new ArrayList<number>();
      temp.add(message[index]['0']);
      temp.add(message[index]['1']);
      temp.add(message[index]['2']);
      array.add(temp);
    }
    //console.info("begin= "+array[0].toString()+"length = "+array.length)
    return array;
  }

  static  to_arr_time(message):ArrayList<Date>{
    let array = new ArrayList<Date>();
    for(let index of Object.keys(message)){
      array.add(message[index]);
    }
    //console.info("begin= "+array[0].toString()+"length = "+array.length)
    return array;
  }

  // --------------------数组装配部分 -------------------------//

}
