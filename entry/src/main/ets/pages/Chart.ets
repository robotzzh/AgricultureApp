
import { McLineChart, Options } from '@mcui/mccharts'
import FarmBean from '../common/bean/FarmBean';
import MainViewModel from '../models/MainViewModel';
import ArrayList from '@ohos.util.ArrayList';
import History_Info from '../common/History_Info';
import router from '@ohos.router';

@Entry
@Component
struct Chart {
  @State value:number[] = [];
  @State time_axis: string[] = [];
  @State usage: string = router.getParams()?.['usage'];
  @State data:ArrayList<number>  = router.getParams()?.['data'];
  @State time_period:ArrayList<Date> = router.getParams()?.['time_epoch'];
  @State length: number = router.getParams()?.['length'];
  @State defOption: Options = new Options({
    xAxis:{
      data:this.time_axis
    },
    yAxis:{
      name:this.translate_Chinese(this.usage)
    },
    series:[
      {
        name:this.translate_Chinese(this.usage)+"历史数据",
        data:this.value
      }
    ]
  })
  build() {
    Row() {
      Column() {
        McLineChart({
          options: this.defOption
        })
      }
      .height('70%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f2f3')
  }

  aboutToAppear(){

    for(let i=0;i<this.length;i++){
      this.value.push(this.data[i])
      const dateObj:string = this.time_period[i].toString();

      //console.info(dateObj)
      let timeString = dateObj.substring(11, 19);
      //console.info(timeString)
      this.time_axis.push(timeString)
      // 获取时间部分

    }


  }

  translate_Chinese(word:string): string{
    if(word == 'temperature')  return '温度';
    if(word == 'humidity') return '空气湿度';
    if(word == 'co2') return '二氧化碳浓度';
    if(word == 'lumination') return '光照强度';
    if(word == 'soilHumidity') return '土壤湿度';
    if(word == 'N') return '氮含量';
    if(word == 'P') return '磷含量';
    if(word == 'K') return "钾含量";
    if(word == 'conductivity') return '电导率';
     return '无该单词'
  }
}