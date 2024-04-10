import FarmBean from '../common/bean/FarmBean';
import MainViewModel from '../models/MainViewModel';
import ArrayList from '@ohos.util.ArrayList';
@Component
export struct WaterPlanComponent{
  @State farmBean : ArrayList<FarmBean> = null;
  @State begin_time : string = '9:30'
  @State duration : string = '0:00'
  @State farmId : Array<number> =  new Array<number>();
  @State farmIdIndex : number = 0;
  private timerId: number = 0;
  build(){
    Column({space:8}){
      Text('灌溉方案')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Orange)
        .margin({ top: 10 })
      Divider().width('95%')
      Row(){
        Text('农田编号')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
        Text(this.farmBean[this.farmIdIndex].fieldId.toString())
          .align(Alignment.End)
        Image($r('app.media.right'))
          .width(30)
          .height(24)
          .onClick(()=>{
              this.farmIdIndex = this.farmIdIndex == this.farmId.length - 1? 0 : this.farmIdIndex+1;
            console.info(this.farmIdIndex.toString())
          })
      }
      .width('95%')
      .justifyContent(FlexAlign.SpaceBetween)
      Row(){
        Text('农田名称')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
        Text(this.farmBean[this.farmIdIndex].name)
      }
      .width('95%')
      .justifyContent(FlexAlign.SpaceBetween)
      Divider().width('95%')
      Text('手动灌溉')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Orange)
        .margin({ top: 10 })
      Row(){
        Text('打开水阀')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
        Toggle({type:ToggleType.Switch,isOn:false})
      }
      .width('95%')
      .justifyContent(FlexAlign.SpaceBetween)
      Divider().width('95%')

      Text('定时灌溉')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Orange)
        .margin({ top: 10 })
      Row(){
        Text('频率')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
        Row(){
          Radio({ value: '1',group: 'frequency'}).checked(true)
          Text("每天")
        }
        Row(){
          Radio({ value: '2',group: 'frequency'}).checked(true)
          Text("每周")
        }
        Row(){
          Radio({ value: '3',group: 'frequency'}).checked(true)
          Text("每月")
        }
      }
      .width('95%')
      .justifyContent(FlexAlign.SpaceBetween)
      Row() {
        Text('开始时间')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
        Image($r('app.media.right')) // 时间自减
          .width(22)
          .height(22)
          .onClick(()=>{
            this.begin_time = this.subtract_time(this.begin_time)
          })
        Text(this.begin_time)
        Image($r('app.media.right'))
          .width(22)
          .height(22)
          .onClick(()=>{
            this.begin_time = this.add_time(this.begin_time)
          })
      }
        .width('95%')
        .justifyContent(FlexAlign.SpaceBetween)
        Row(){
          Text('持续时间')
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
          Image($r('app.media.right')) // 时间自减
            .width(22)
            .height(22)
            .onClick(()=>{
              this.duration = this.subtract_time(this.duration)
            })
          Text(this.duration)
          Image($r('app.media.right')) // 时间自增
            .width(22)
            .height(22)
            .onClick(()=>{
              this.duration = this.add_time(this.duration)
            })
        }
        .width('95%')
        .justifyContent(FlexAlign.SpaceBetween)
        Row(){
          Text('水阀控制')
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
          Toggle({type:ToggleType.Switch,isOn:false})
        }
        .width('95%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#f1f2f3')

    }


  add_time(time:string){
    //时间自增函数
    let Time : string[] = time.split(':');
    let hour : number = Number(Time[0])
    let minutes : number = Number(Time[1])
    let handle : boolean = false
    if(minutes == 50 && hour != 23 && !handle){
      hour = hour + 1;
      minutes = 0;
      handle = true
    }
    if(minutes == 50 && hour == 23 && !handle){
      hour = 0;
      minutes = 0;
      handle = true
    }
    if(minutes != 50 && !handle){
      minutes = minutes + 10;
      handle = true
    }
    if(minutes == 0 && handle){
      return hour.toString() +":" + minutes.toString() + "0"
    }
    console.log("now time is"+hour.toString() + minutes.toString())
    return hour.toString() +":" + minutes.toString()
  }


  subtract_time(time:string){
    let Time : string[] = time.split(':');
    let hour : number = Number(Time[0])
    let minutes : number = Number(Time[1])
    let handle : boolean = false
    if(minutes == 0 && hour != 0 && !handle){
      hour = hour - 1;
      minutes = 50;
      handle = true
    }
    if(minutes == 0 && hour == 0 && !handle){
      hour = 23;
      minutes = 50;
      handle = true
    }
    if(minutes != 0 && !handle){
      minutes = minutes - 10;
      handle = true
    }
    if(minutes == 0){
      return hour.toString() +":" + minutes.toString() + "0"
    }
    console.log("now time is"+hour.toString() + minutes.toString())
    return hour.toString() +":" + minutes.toString()
  }


  loadFarmData( sensor_ID: number){
    /*
    //MainViewModel.getFarmData(sensor_ID);// 此处返回农田信息
    this.farmBean = MainViewModel.getFarmData(sensor_ID);*/
    MainViewModel.getFarmData(sensor_ID);
    this.farmBean = MainViewModel.farmBean;
  }

  aboutToAppear(){
    //当页面出现时获取设备数据
    this.loadFarmData(1);
    this.farmBean.forEach((value)=>{
        this.farmId.push(value.fieldId);
    });
    //每隔5秒加载一次数据
    this.timerId = setInterval(()=>{
      //MainViewModel.refresh_data();
      this.loadFarmData(1);
    },30*1000)
  }

}