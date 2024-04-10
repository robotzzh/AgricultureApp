@Entry
@Component
struct PersonalInformation {
  @State username: string = 'Hello World'
  @State password: string = '123456'
  build() {
    Row() {
      Column() {
        Text('USERNAME:')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Text(this.username)
      }
      Column() {
        Text('PASSWORD:')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Text(this.password)
      }
      .width('100%')
    }
    .height('100%')
  }
}