import ArrayList from '@ohos.util.ArrayList';
import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import DistributedUtil from '../../DB/DistributedUtil';

export default class FarmBean{
  fieldId : number;
  name: string;
  temperature: number;
  humidity: number;
  co2: number;
  lumination: number;
  soilHumidity: number;
  sensor_IP : string;
  sensor_port: number;
  NPK: ArrayList<number>;
  PH: number;
  conductivity: number;

  constructor(fieldId : number,
              name: string,
              temperature: number,
              humidity: number,
              co2: number,
              lumination: number,
              soilHumidity: number,
              sensor_IP: string,
              sensor_port: number,
              NPK: ArrayList<number>,
              PH: number,
              conductivity:number) {
    this.fieldId = fieldId;
    this.name = name;
    this.temperature = temperature;
    this.humidity = humidity;
    this.co2 = co2;
    this.lumination = lumination;
    this.soilHumidity = soilHumidity;
    this.sensor_IP = sensor_IP;
    this.sensor_port = sensor_port;
    this.NPK = NPK;
    this.PH = PH;
    this.conductivity = conductivity;
  }



  //将自身转化为JSON
  /*
   * e.g.
   *写部分
   arr.add(1),arr.add(2),arr.add(2);
    let f2 = new FarmBean(2,'农田2',22.5,56,30,800,25,'123.0.0.1',11111,arr,7,16);
    let message = fs.writeSync(file.fd, f2.to_JSON());
    * 读部分
    let buf = new ArrayBuffer(100000);
    let readLen = fs.readSync(file.fd, buf, { offset: 0 });
    let str:string = String.fromCharCode.apply(null, new Uint8Array(buf.slice(0, readLen)));
    let data:FarmBean = FarmBean.JSON_to(JSON.parse(str))
   * */
  // --------------------json转化部分（finished)------------------//
  to_JSON():string{
    var temp ={
      fieldId:this.fieldId,
      name: this.name,
      temperature: this.temperature,
      humidity: this.humidity,
      co2: this.co2,
      lumination: this.lumination,
      soilHumidity: this.soilHumidity,
      sensor_IP : this.sensor_IP,
      sensor_port: this.sensor_port,
      NPK : this.NPK,
      PH: this.PH,
      conductivity : this.conductivity
    }
    return JSON.stringify(temp);
  }

  //给一个JSON对象，返回一个FarmBean
  static JSON_to(message):FarmBean{
    var temp:FarmBean = new FarmBean(
      message.fieldId,
      message.name,
    message.temperature,
    message.humidity,
    message.co2,
    message.lumination,
    message.soilHumidity,
    message.sensor_IP,
    message.sensor_port,
    message. NPK,
    message.PH,
    message.conductivity,
    );
    return temp;
  }

  // --------------------json转化部分（finished)------------------//
  //废弃，生成一个test+farmId.json的json文件用于存储农田信息，在FarmBean文件夹下
  /*
  Json_save(){
    let context = getContext(this)  as common.UIAbilityContext;
    let filesDir = context.filesDir;
    let filenames : string[];
    let dirPath_cache = filesDir + '/FarmBean';
    fs.access(dirPath_cache).then((res) => {
      if (res) {
        // 获取文件夹内所有内容
        let filepath = filesDir+"/FarmBean"+'/test'+this.fieldId.toString()+'.json';
        let file = fs.openSync(filepath,fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        console.info(filesDir+"/FarmBean"+'/test'+this.fieldId.toString()+'.json');
        //let message = fs.writeSync(file.fd, f2.to_JSON());
        fs.writeSync(file.fd, this.to_JSON());
        //console.info("The length of str is: " + message+"and main is"+f2.to_JSON());
        console.info('data has been loaded');
        return true;

      }
    }).catch((err) => {
      console.error("access failed with error message: " + err.message + ", error code: " + err.code);
    });
  }
*/

  // --------------------数据库操作部分（finished)------------------//
  save_db(){
    DistributedUtil.putStoreData(this.fieldId.toString(),this.to_JSON());
    console.info('successfully save in db')
  }

  static async read_db(id: string): Promise<FarmBean> {
    try {
      const res = await DistributedUtil.getStoreData(id);
      const jsonObject = JSON.parse(JSON.parse(JSON.stringify(res)));
      console.log('farm_bean===获取数据库中的数据====read from db',typeof  jsonObject);
      console.info(jsonObject.temperature)
      const temp = FarmBean.JSON_to(jsonObject);
      console.info("farm temperature:" + temp.temperature);
      return temp;
    } catch (error) {
      console.error('Error reading from database:', error);
      return null;
    }
  }

  delete_db(id:string){
    DistributedUtil.deleteStoreData(id);
  }


  // --------------------数据库操作部分（finished)------------------//
  //给定一个Farm_index,获取JSON中的数据
  //弃用
  /*
  static read_Json(index:number):FarmBean{
    let context = getContext(this)  as common.UIAbilityContext;
    let filesDir = context.filesDir;
    let data: FarmBean = null;
    fs.listFile(filesDir+'/FarmBean').then((filenames) => {
      console.info("listFile succeed");
      if(filenames.length == 0 ) console.info('no file in '+filesDir+'/FarmBean');
      else {
        for (let i = 0; i < filenames.length; i++) {
          const regex = /test(\d+)\.json/; // 正则表达式匹配test后面的数字
          const match = filenames[i].match(regex); // 使用正则表达式匹配字符串

          if (match) {
            const numberStr = match[1]; // 第一个捕获组对应的匹配结果，即数字字符串
            const number = parseInt(numberStr, 10); // 将字符串转换为数字
            console.log('farmId:', number);
            if(number == index){
              let context = getContext(this)  as common.UIAbilityContext;
              let filesDir = context.filesDir;
              console.info(filesDir+'/FarmBean'+ '/'+filenames[i]);
              let file = fs.openSync(filesDir+'/FarmBean'+ '/'+filenames[i],fs.OpenMode.READ_ONLY);
              let buf = new ArrayBuffer(100000);
              let readLen = fs.readSync(file.fd, buf, { offset: 0 });
              let str :string = String.fromCharCode.apply(null, new Uint8Array(buf.slice(0, readLen)));
              let decodedString = decodeURIComponent(str);//没有这一步中文会乱码
              console.info(decodedString)
              console.log("读取文件内容："+decodedString);
              //let data = JSON.parse(str)
              data= FarmBean.JSON_to(JSON.parse(str));
            }
          }
        }
      }
    }).catch((err) => {
      console.error("list file failed with error message: " + err.message + ", error code: " + err.code);
    });
    return data;
  }

* */


  //----------------- 数据修改部分 ----------------//
  alert_fieldId(fieldId : number){
    this.fieldId = fieldId;
  }
  alert_name(name: string){
    this.name = name;
  }
  alert_temperature(temperature : number){
    this.temperature = temperature;
  }
  alert_humidity(humidity : number){
    this.humidity = humidity;
  }
  alert_co2(co2 : number){
    this.co2 = co2;
  }
  alert_lumination(lumination : number){
    this.lumination = lumination;
  }
  alert_soilHumidity(soilHumidity: number){
    this.soilHumidity = soilHumidity;
  }
  alert_N(N:number){
    this.NPK[0] = N
  }
  alert_P(P:number){
    this.NPK[1] = P
  }
  alert_K(K:number){
    this.NPK[2] = K
  }
  alert_conductivity(conductivity:number){
    this.conductivity = conductivity;
  }
  alert_sensor_IP(sensor_IP:string){
    this.sensor_IP = sensor_IP;
  }
  alert_sensor_port(sensor_port:number){
    this.sensor_port = sensor_port;
  }
  change_net(IP:string,port:number){
    this.alert_sensor_IP(IP);
    this.alert_sensor_port(port);
  }
  //----------------- 数据修改部分 ----------------//
}