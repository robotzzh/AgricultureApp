import FarmBean from '../common/bean/FarmBean';
import TCP from '../socket/TCP'
import ArrayList from '@ohos.util.ArrayList';
import History_Info from '../common/History_Info';
import fs from '@ohos.file.fs';
//import { BusinessError } from '@ohos.base';
import {CodeLIST, Item} from '../models/Code'
import connection from '@ohos.net.connection'
import osAccount from '@ohos.account.osAccount';
import LinkedList from '@ohos.util.LinkedList';
import systemDateTime from '@ohos.systemDateTime';


export class MainViewModel{

  private IP_address:string = '10.10.100.254';
  private port : number = 15000;
  public farmBean : ArrayList<FarmBean> = new ArrayList();
  public history_info : ArrayList<History_Info> = new ArrayList<History_Info>();
  //public farmBean: FarmBean[] = [];



  // 192.168.1.151

  public refresh_data(Index: number){
//TODO:将本地IP改成wifi解码
    let tcp =new TCP('10.0.2.15',12345,this.farmBean[Index].sensor_IP, this.farmBean[Index].sensor_port);
    tcp.connect();
    tcp.subscribe();

    connection.getAppNet(function(error, data) {
      console.log("info: "+JSON.stringify(error))
      console.log("error info: "+JSON.stringify(data))
    })

    //let s_tcp = new TCP('10.0.2.15', 12344, '192.168.1.9', 12345);
    // 指令寻问遍历
    CodeLIST.forEach((value,index)=>{
      setTimeout(()=> {
        let s_tcp = new TCP('10.0.2.16', 12344, this.farmBean[Index].sensor_IP, this.farmBean[Index].sensor_port);
        //console.info(i.toString());
        s_tcp.join(value.code)
        s_tcp.send();
      },index*1200)
    })

    setTimeout(()=>{
      console.info("information len = "+tcp.cache_info.length.toString())
      console.info(tcp.cache_info[0])
      tcp.cache_info.forEach((value,index)=>{
        let decimalNumber = parseInt(value, 16);
        switch (index){
          case 0:
            this.farmBean[Index].alert_temperature(decimalNumber/10);
            console.info('--------temperature changed---------'+(decimalNumber/10).toString())
            break;
          case  1:
            this.farmBean[Index].alert_humidity(decimalNumber/10);
            console.info('--------humidity changed---------'+(decimalNumber/10).toString())
            console.info(this.farmBean[Index].humidity)
            break;
          case 2:
            this.farmBean[Index].alert_N(decimalNumber);
            console.info('--------N changed---------'+(decimalNumber).toString())
            break;
          case 3:
            this.farmBean[Index].alert_P(decimalNumber);
            console.info('--------P changed---------'+(decimalNumber).toString())
            break;
          case 4:
            this.farmBean[Index].alert_K(decimalNumber);
            console.info('--------K changed---------'+(decimalNumber).toString())
            break;
          case 5:
            this.farmBean[Index].alert_conductivity(decimalNumber);
            console.info('--------N changed---------'+(decimalNumber).toString())
            break;
          default :
            console.info("locked")
        }
      })

    },15*1000)
    //十五秒后显示出所有的十六进制数
    setTimeout(()=>{
      tcp.close();
      console.info('end epoch')
    },20*1000)
    //关闭监听端口

  }

  /*
  public loadFarmData(fieldId:number ,
                      name:string,
                      sensor_IP:string,
                      sensor_port: number,
  ):FarmBean{
    let his_info = new History_Info(fieldId,
      name,
      sensor_IP,
      sensor_port);
    //TODO 从cache把内存数据加载到这里
    //TODO 把最后一个历史信息装填为Farmbean
    let last_farm_bean : FarmBean = his_info.to_farm_bean(his_info.history_humidity.length-1);
    return last_farm_bean;
  }
*/

  public  async getFarmData(fieldId:number):Promise<boolean>{

    let f1:FarmBean = this.farmBean[0];
    let f2:FarmBean = this.farmBean[1];
    //console.info('tem: '+ this.farmBean[0].temperature + " and"+ f1.temperature)
    setTimeout(()=>{
      //处理保存farm_bean进DB
      //console.info("temp"+f1.temperature.toString())
      f1.save_db();
      f2.save_db();
      console.info('fb save in db');

    },100);
    setTimeout(async ()=>{
      //从DB阅读1，2进入内存
      this.farmBean[0] = await FarmBean.read_db('1');
      this.farmBean[1] = await FarmBean.read_db('2');

    },400);

    setTimeout(()=>{

      let temp1:History_Info= this.history_info[0];
      let temp2:History_Info= this.history_info[1];
      let f1:FarmBean = this.farmBean[0];
      let f2:FarmBean = this.farmBean[1];
      temp1.FarmBean_to_History(f1)
      temp2.FarmBean_to_History(f2)
      console.info('successfully load new data to history')
    },800)

    setTimeout(()=>{
      let temp1:History_Info= this.history_info[0];
      let temp2:History_Info= this.history_info[1];
      temp1.save_db();
      temp2.save_db();
      console.info("history successfully saved")
    },2000)

    setTimeout(async ()=>{
      let t1 = await History_Info.read_db('1');
      let t2 = await History_Info.read_db('2');
      //let t3 = await History_Info.read_db('3');
      //console.info(JSON.stringify(t3))
      this.history_info[0] = t1;
      this.history_info[1] = t2;
      //console.info("leng"+t1.history_humidity.length)
      //this.history_info[1] = await History_Info.read_db('2');
      console.info(JSON.stringify(t1))
      console.info("history successfully read")

    },3000);
    return true;

  }


  alert_sensor_net(farmId:number,IP:string,port:number):boolean{
    this.farmBean.forEach((value)=> {
      if (value.fieldId == farmId) {
        console.info(value.fieldId.toString() + value.sensor_IP + value.sensor_port.toString() + "is changing");
        value.sensor_IP = IP;
        value.sensor_port = port;
        console.info(farmId + IP + port.toString() + "has been changed")
        return true;
      }
    });
      return false;
  }

  async fetch_history():Promise<number>{
      if(await History_Info.read_db('1') == null) {
        const f1 = this.farmBean[0];
        const f2 = this.farmBean[1];
        let temp1 = new History_Info(f1.fieldId, f1.name, f1.sensor_IP, f1.sensor_port);
        let temp2 = new History_Info(f2.fieldId, f2.name, f2.sensor_IP, f2.sensor_port);
        temp1.FarmBean_to_History(f1);

        temp2.FarmBean_to_History(f2);

        this.history_info.add(temp1);

        this.history_info.add(temp2);

        console.info("len of history:"+this.history_info.length.toString())
        // 1模式为从内存中构造
      //console.info(JSON.stringify(await History_Info.read_db('1')))
      console.info('history info download')
        return 1;
    }

    else
    {
      let temp1 = await History_Info.read_db('1');
      let temp2 = await History_Info.read_db('2');
      this.history_info.add(temp1);
      this.history_info.add(temp2);
      console.info("len of history:" + this.history_info.length.toString())
      console.info('history info download from db');
      //2模式为从数据库中读取
      return 2;
    }
}

  async delete_history_db(history_id:string):Promise<boolean>{
    try {
      await this.fetch_history();
      const f1 = await FarmBean.read_db('1');
      const f2 = await FarmBean.read_db('2');
      let temp1 = new History_Info(f1.fieldId, f1.name, f1.sensor_IP, f1.sensor_port);
      let temp2 = new History_Info(f2.fieldId, f2.name, f2.sensor_IP, f2.sensor_port);
      temp1.FarmBean_to_History(f1);

      temp2.FarmBean_to_History(f2);

      this.history_info[0]=temp1;

      this.history_info[1]=temp2;

      History_Info.delete_db(history_id)
      console.info(history_id + "history database has been deleted");
      return true;
    }catch (e){
      console.info(history_id + "history database can't be deleted error"+e);
      return false;
    }
  }

  to_NPK(farm_index:number,operation:number):ArrayList<number>{
    let temp:History_Info = this.history_info[farm_index];
    let array = new ArrayList<number>();
    temp.history_NPK.forEach((value,index)=>{
      array.add(value[operation])
    })
    return array;
  }
}

export default new MainViewModel();
/*
 此处用于读区数据
*/