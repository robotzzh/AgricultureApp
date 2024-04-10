import FarmBean from '../common/bean/FarmBean';
import MainViewModel from '../models/MainViewModel';
import ArrayList from '@ohos.util.ArrayList';
import History_Info from '../common/History_Info';
import TCP from '../socket/TCP';
import  {CodeLIST} from '../models/Code'
import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import systemDateTime from '@ohos.systemDateTime';
import connection from '@ohos.net.connection';
import router from '@ohos.router'

@Component
export default struct  HomeComponent{
  @State farmBean : ArrayList<FarmBean> = null;
  @State farmIndex : number = 0;
  @State Select_options : ArrayList<SelectOption> = new ArrayList<SelectOption>();

  private timerId: number = 0;
  build(){
    Column({space:7}) {
      Text('选择农田')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Orange)
        .margin({ top: 10 })
      Row(){
        Select(/*[
          {value: '农田1', icon: $r('app.media.icon') },
          {value: '农田2',icon: $r('app.media.icon')},
          {value: '农田3',icon: $r('app.media.icon')},
          {value: '农田4',icon: $r('app.media.icon')}
        ]*/
        this.Select_options.convertToArray())
          .selected(0)
          .value('选择农田')
          .font({size:24, weight: 600})
          .selectedOptionFont({size: 24,weight:500})
          .optionFont({size: 24,weight:500})
          .onSelect((index:number, text?: string | undefined)=>{
            if(index < this.farmBean.length){
              this.farmIndex = index
              console.info(this.farmBean.length.toString())
              console.info('Select:' + index)
            }
            else{
              this.farmIndex = this.farmBean.length - 1
              console.info("select error")
            }
          })
      }

      Divider().width('95%')
      Text('传感器数据')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Orange)
        .margin({ top: 10 })
      /*
      每隔五秒钟刷新一次
      Button('刷新')
        .onClick(()=>{
          MainViewModel.refresh_data();
        })
        * */
      Divider().width('95%')

      Row(){
        Text('温度')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
        Text(String(this.farmBean[this.farmIndex].temperature)+"度")
          .fontSize(18)
      }
      .width('95%')
      .justifyContent(FlexAlign.SpaceBetween)
      .onClick(()=>{
        router.pushUrl({
          url:"pages/Chart",
          params: {
            usage: 'temperature',
            data:MainViewModel.history_info[this.farmIndex].history_temperature,
            time_epoch: MainViewModel.history_info[this.farmIndex].time_axis,
            length: MainViewModel.history_info[this.farmIndex].history_temperature.length,
          }
        })
      })

      Row(){
        Text('空气湿度')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
        Text(String(this.farmBean[this.farmIndex].humidity)+"%")
          .fontSize(18)
      }
      .width('95%')
      .justifyContent(FlexAlign.SpaceBetween)
      .onClick(()=>{
        router.pushUrl({
          url:"pages/Chart",
          params: {
            usage: 'humidity',
            data:MainViewModel.history_info[this.farmIndex].history_humidity,
            time_epoch: MainViewModel.history_info[this.farmIndex].time_axis,
            length: MainViewModel.history_info[this.farmIndex].history_temperature.length,
          }
        })
      })

      Row(){
        Text('二氧化碳浓度')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
        Text(String(this.farmBean[this.farmIndex].co2)+'ppm')
          .fontSize(18)
      }
      .width('95%')
      .justifyContent(FlexAlign.SpaceBetween)
      .onClick(()=> {
        router.pushUrl({
          url: "pages/Chart",
          params: {
            usage: 'co2',
            data: MainViewModel.history_info[this.farmIndex].history_co2,
            time_epoch: MainViewModel.history_info[this.farmIndex].time_axis,
            length: MainViewModel.history_info[this.farmIndex].history_co2.length,
          }
        })
      })

      Row(){
        Text('光照')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
        Text(String(this.farmBean[this.farmIndex].lumination)+'Lux')
          .fontSize(18)
      }
      .width('95%')
      .justifyContent(FlexAlign.SpaceBetween)
      .onClick(()=> {
        router.pushUrl({
          url: "pages/Chart",
          params: {
            usage: 'lumination',
            data: MainViewModel.history_info[this.farmIndex].history_lumination,
            time_epoch: MainViewModel.history_info[this.farmIndex].time_axis,
            length: MainViewModel.history_info[this.farmIndex].history_lumination.length,
          }
        })
      })

      Row(){
        Text('土壤湿度')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
        Text(String(this.farmBean[this.farmIndex].soilHumidity)+'%')
          .fontSize(18)
      }
      .width('95%')
      .justifyContent(FlexAlign.SpaceBetween)
      .onClick(()=> {
        router.pushUrl({
          url: "pages/Chart",
          params: {
            usage: 'soilHumidity',
            data: MainViewModel.history_info[this.farmIndex].history_soilHumidity,
            time_epoch: MainViewModel.history_info[this.farmIndex].time_axis,
            length: MainViewModel.history_info[this.farmIndex].history_soilHumidity.length,
          }
        })
      })

      Row(){
        Text('氮含量')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
        Text(String(this.farmBean[this.farmIndex].NPK[0])+'mg/kg')
          .fontSize(18)
      }
      .width('95%')
      .justifyContent(FlexAlign.SpaceBetween)
      .onClick(()=> {
        router.pushUrl({
          url: "pages/Chart",
          params: {
            usage: 'N',
            data: MainViewModel.to_NPK(this.farmIndex,0),
            time_epoch: MainViewModel.history_info[this.farmIndex].time_axis,
            length: MainViewModel.to_NPK(this.farmIndex,0).length,
          }
        })
      })

      Row(){
        Text('磷含量')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
        Text(String(this.farmBean[this.farmIndex].NPK[1])+'mg/kg')
          .fontSize(18)
      }
      .width('95%')
      .justifyContent(FlexAlign.SpaceBetween)
      .onClick(()=> {
        router.pushUrl({
          url: "pages/Chart",
          params: {
            usage: 'P',
            data: MainViewModel.to_NPK(this.farmIndex,1),
            time_epoch: MainViewModel.history_info[this.farmIndex].time_axis,
            length: MainViewModel.to_NPK(this.farmIndex,1).length,
          }
        })
      })

      Row(){
        Text('钾含量')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
        Text(String(this.farmBean[this.farmIndex].NPK[2])+'mg/kg')
          .fontSize(18)
      }
      .width('95%')
      .justifyContent(FlexAlign.SpaceBetween)
      .onClick(()=> {
        router.pushUrl({
          url: "pages/Chart",
          params: {
            usage: 'K',
            data: MainViewModel.to_NPK(this.farmIndex,2),
            time_epoch: MainViewModel.history_info[this.farmIndex].time_axis,
            length: MainViewModel.to_NPK(this.farmIndex,2).length,
          }
        })
      })

      Row(){
        Text('电导率')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
        Text(String(this.farmBean[this.farmIndex].conductivity)+'S/m')
          .fontSize(18)
      }
      .width('95%')
      .justifyContent(FlexAlign.SpaceBetween)
      .onClick(()=> {
        router.pushUrl({
          url: "pages/Chart",
          params: {
            usage: 'conductivity',
            data: MainViewModel.history_info[this.farmIndex].history_conductivity,
            time_epoch: MainViewModel.history_info[this.farmIndex].time_axis,
            length: MainViewModel.history_info[this.farmIndex].history_conductivity.length,
          }
        })
      })

      //TODO:功能测试
      /*
      Button('功能测试')
        .onClick(()=> {
          this.farmBean[this.farmIndex].Json_save();
          //FarmBean.read_Json(1)
          let context = getContext(this)  as common.UIAbilityContext;
          let filesDir = context.filesDir;
          fs.listFile(filesDir+'/FarmBean').then((filenames) => {
            console.info("listFile succeed");
            if(filenames.length == 0 ) console.info('no file in '+filesDir+'/FarmBean');
            else {
              for (let i = 0; i < filenames.length; i++) {
                console.info("fileName:" +filenames[i]+" in "+filesDir+'/FarmBean', filenames[i]);
              }
            }
          }).catch((err) => {
            console.error("list file failed with error message: " + err.message + ", error code: " + err.code);
          });
          //this.farmBean[this.farmIndex].Json_save();
          //let temp = new History_Info(1,'lihua','127.0.0.1',12345);
          //temp.load();
          //MainViewModel.refresh_data(this.farmIndex);

        })
        * */
    Button('刷新')
      .onClick(()=> {

        //let temp = new History_Info(1,'lihua','127.0.0.1',12345);
        //temp.load();
        MainViewModel.refresh_data(this.farmIndex);

      })

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f2f3')

  }

  loadFarmData( sensor_ID: number){
    //MainViewModel.getFarmData(sensor_ID);// 此处返回农田信息
    MainViewModel.getFarmData(sensor_ID);
    this.farmBean = MainViewModel.farmBean;
  }

  aboutToAppear(){
    //当页面出现时获取设备数据
    this.loadFarmData(1);
    //console.info("Name: "+this.farmBean[0].name);
    this.farmBean.forEach((value)=>{
      this.Select_options.add({value:value.name,icon:$r('app.media.icon')});
    });
    //每隔5秒加载一次数据
    this.timerId = setInterval(()=>{
      MainViewModel.refresh_data(this.farmIndex);
    },60*1000)
    //MainViewModel.close_listen();
  }

  to_NPK(index:number):ArrayList<number>{
    let array:ArrayList<number> = new ArrayList<number>();
    for(let i=0;i<MainViewModel.history_info[this.farmIndex].history_conductivity.length;i++){
      array.add(MainViewModel.history_info[this.farmIndex].NPK[i][index])
    }
    return array;
  }

}