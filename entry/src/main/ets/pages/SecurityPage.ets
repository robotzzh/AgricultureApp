import FarmBean from '../common/bean/FarmBean';
import MainViewModel from '../models/MainViewModel';

@Entry
@Component
struct SecurityPage {
  //@State message: string = 'Hello World'
  @State account: string='' // 绑定账号
  @State history_id: string='1' //绑定密码

  build() {
    Flex({direction:FlexDirection.Column,
      alignItems:ItemAlign.Center,
      justifyContent:FlexAlign.SpaceAround
    }){
      Text('安全页面')
        .fontSize(32)
        .fontColor(Color.Blue)
        .fontWeight(FontWeight.Bold)
      // 密码输入区
      Column({space:10}){
        TextInput({placeholder:'历史文件ID： '})
          .type(InputType.Normal)
          .backgroundColor(Color.Gray)
          .fontSize(Color.Brown)
          .onChange((value)=>{
            this.history_id = value;

          })
        Text("ID:"+this.history_id)
        Button('删除')
          .width('95%')
          .backgroundColor(Color.Gray)
          .margin({top:10})
          .onClick(async ()=>{
            await MainViewModel.delete_history_db(this.history_id)
            console.info('')
          })
      }.width('90%')
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.home1')) // $app.media/element.profile引用文件
    .backgroundImageSize(ImageSize.Cover)
  }
}