import FarmBean from '../common/bean/FarmBean';
import MainViewModel from '../models/MainViewModel';
import ArrayList from '@ohos.util.ArrayList';
@Entry
@Component
struct RegardingPage {
  @State message: string = 'this is regarding page'
  @State farmBean : ArrayList<FarmBean> = null;
  private timerId = 0;
  @State Select_options : ArrayList<SelectOption> = new ArrayList<SelectOption>();
  @State farmIndex : number = 0;
  private Ip:string;
  private port:number;

  build() {
    Column() {
      Row() {
        Select(this.Select_options.convertToArray())
          .selected(0)
          .value('选择农田')
          .font({ size: 24, weight: 600 })
          .selectedOptionFont({ size: 24, weight: 500 })
          .optionFont({ size: 24, weight: 500 })
          .onSelect((index: number, text?: string | undefined) => {
            if (index < this.farmBean.length) {
              this.farmIndex = index
              console.info(this.farmBean.length.toString())
              console.info('Select:' + index)
            }
            else {
              this.farmIndex = this.farmBean.length - 1
              console.info("select error")
            }
          })
      }
      .width('100%')
      .height('100%')
      .backgroundImage($r('app.media.home1')) // $app.media/element.profile引用文件
      .backgroundImageSize(ImageSize.Cover)

      Divider().width('95%')
      Row() {
        Column() {
          Text(this.message)
            .fontSize(50)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
        Column({space:10}) {
          TextInput({ placeholder: 'IP：' })
            .backgroundColor(Color.Gray)
            .fontSize(Color.Brown)
            .onChange((value) => {
              this.Ip = value;
            })
          TextInput({ placeholder: '端口： ' })
            .type(InputType.Password)
            .backgroundColor(Color.Gray)
            .fontSize(Color.Brown)
            .onChange((value) => {
              this.port = parseInt(value);
            })
          Button('修改')
            .width('95%')
            .margin({ top: 10 })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundImage($r('app.media.home1')) // $app.media/element.profile引用文件
      .backgroundImageSize(ImageSize.Cover)
    }
  }

  loadFarmData( sensor_ID: number){
    //MainViewModel.getFarmData(sensor_ID);// 此处返回农田信息
    MainViewModel.getFarmData(sensor_ID);
    this.farmBean = MainViewModel.farmBean;
  }

  aboutToAppear() {
    //当页面出现时获取设备数据
    this.loadFarmData(1);
    this.farmBean.forEach((value) => {
      this.Select_options.add({ value: value.name, icon: $r('app.media.icon') });
    });
    //每隔5秒加载一次数据
    this.timerId = setInterval(() => {
      //MainViewModel.refresh_data();
      this.loadFarmData(1);
    }, 5000)
  }
}