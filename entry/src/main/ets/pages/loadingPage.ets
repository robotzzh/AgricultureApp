import router from '@ohos.router';
import fs from '@ohos.file.fs';
import { TabItemList } from '../models/TabItem';
import common from '@ohos.app.ability.common';
import MainViewModel from '../models/MainViewModel';
import FarmBean from '../common/bean/FarmBean';
import ArrayList from '@ohos.util.ArrayList';
import History_Info from '../common/History_Info';
@Entry
@Component
struct LoadingPage {
  @State message: string = 'load \n';
  private timerId: number = -1;
  @State showSeconds: number = 3;

  build() {
    Flex({ direction: FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.SpaceAround
    }) {
      Text(this.message+String(this.showSeconds))
        .fontSize(40)
        .fontColor(Color.Blue)
        .fontWeight(FontWeight.Bold)
      LoadingProgress().color(Color.Blue)
        .width('50%')
        .height('50%')
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.home1')) // $app.media/element.profile引用文件
    .backgroundImageSize(ImageSize.Cover)
  }
  async aboutToAppear() {
    this.timerId = setInterval(() => {
      if (this.showSeconds > 0) {
        this.showSeconds--;
      } else {
        clearInterval(this.timerId)
        router.pushUrl({
          url: 'pages/MainPage'
        })
      }
    }, 1 * 1000)

    let context = getContext(this) as common.UIAbilityContext;
    let NPK = new ArrayList<number>();
    NPK.add(0.1);
    NPK.add(0.3);
    NPK.add(0.2);
    let PH: number = 7;
    let conductivity: number = 0.12
    let IP_address: string = '10.10.100.254';
    let port: number = 15000;
    let f1 = new FarmBean(1, '赵4家冰天', 22.5, 56, 30, 800, 25, IP_address, port, NPK, PH, conductivity);
    let f2 = new FarmBean(2, '农田2', 22.5, 56, 30, 800, 25, IP_address, port, NPK, PH, conductivity);
      setTimeout(()=>{
        f1.save_db();
        f2.save_db()

      },800);

    setTimeout(async ()=>{
      MainViewModel.farmBean.add(await FarmBean.read_db('1'));
      MainViewModel.farmBean.add(await FarmBean.read_db('2'));
    },1600);

    setTimeout(async ()=>{
      MainViewModel.fetch_history();
    },2400)


  }
}