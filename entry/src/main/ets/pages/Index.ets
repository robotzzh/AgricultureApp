import router from '@ohos.router'
@Entry
@Component
struct Index {
  //@State message: string = 'Hello World'
  @State account: string='' // 绑定账号
  @State password: string='' //绑定密码

  build() {
    Flex({direction:FlexDirection.Column,
      alignItems:ItemAlign.Center,
      justifyContent:FlexAlign.SpaceAround
    }){
      Text('登陆页面')
        .fontSize(32)
        .fontColor(Color.Blue)
        .fontWeight(FontWeight.Bold)
      // 密码输入区
      Column({space:10}){
        TextInput({placeholder:'用户名：'})
          .backgroundColor(Color.Gray)
          .fontSize(Color.Brown)
          .onChange((value)=>{
            this.account = value;
          })
        TextInput({placeholder:'密码： '})
          .type(InputType.Password)
          .backgroundColor(Color.Gray)
          .fontSize(Color.Brown)
          .onChange((value)=>{
            this.password = value;
          })
        Button('登陆')
          .width('95%')
          .margin({top:10})
          .onClick(()=>{
            router.pushUrl({
              url:'pages/loadingPage'
            })
          })
        Button('注册')
          .width('95%')
          .backgroundColor(Color.Gray)
          .margin({top:10})
      }.width('90%')
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.home1')) // $app.media/element.profile引用文件
    .backgroundImageSize(ImageSize.Cover)
  }
}