import { InfoItem, MineItemList } from '../models/MineItemList';
import router from '@ohos.router';
import relationalStore from '@ohos.data.relationalStore';
@Component
export struct MineComponent{
  @State nickname: string = 'Jerry';
  @State signature: string = 'hello world'
  build(){
    Column(){
      //Text('用户信息')
      Column(){
        /*
         * 头像信息
         * */
        Image($r('app.media.home1'))
          .width(70)
          .height(70)
          .borderRadius(32)
        Text(this.nickname)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Text(this.signature)
          .fontSize(14)
          .fontColor(Color.Orange)
      }
      .width('95%')
      .margin(20)
      Column(){
        List(){
          //页面id     id:'1',
          //页面作用     title:'个人资料',
          //页面资源     icon:$r("app.media.key")
          ForEach(MineItemList,(item:InfoItem)=>{
          ListItem(){
          //Text(item.title)
            Row(){
              Row(){
                Image(item.icon)
                  .width(38)
                  .height(38)
                Text(item.title)
                  .fontSize(22)
              }
              Image($r('app.media.right')) // 此处日后换成向右
                .width(38)
                .height(38)
                .onClick(()=>{
                router.pushUrl({
                url: item.path,
                })
              })
            }
            .width('100%')
            .height(52)
            .justifyContent(FlexAlign.SpaceBetween)

          }
          },item => JSON.stringify(item))


        }

      }
      .width('100%')
      .border({
        radius:{
          topLeft:20,
          topRight:20
        }
      })
      .backgroundColor('#114f7692')
      .width('100%')
      .height('90%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f2f3')
  }

}