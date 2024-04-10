import  {TabID,TabItemList} from '../models/TabItem';
import HomeComponent from '../view/HomeComponent';
import {WaterPlanComponent} from  '../view/WaterPlanCompinent';
import {MineComponent} from '../view/MineComponent'
@Entry
@Component
struct MainPage {
  @State message: string = 'Main Page'
  private tabController: TabsController= new TabsController();
  @State pageIndex : number = 0;
  build() {
    Tabs({barPosition:BarPosition.End}){
    TabContent(){
      //Text('主页')
      HomeComponent()//主页 在view的HomeComponent中修改
    }
      .tabBar(this.MyTabBuilder(TabID.HOME))
      TabContent(){
        //Text('灌溉计划')
        WaterPlanComponent()
      }
      .tabBar(this.MyTabBuilder(TabID.WATER_PLAN))
      TabContent(){
        //Text('我的')
        MineComponent()
      }
      .tabBar(this.MyTabBuilder(TabID.MINE))
    }
    .barWidth('100%')
    .barMode(BarMode.Fixed)
    .width('100%')
    .height('100%')
    .onChange((index)=>{
      this.pageIndex = index;
    })
  }

  @Builder MyTabBuilder(idx: number){
    Column(){
      Image(idx == this.pageIndex ? TabItemList[idx].icon_select:
      TabItemList[idx].icon)
        .width(32)
        .height(32)
      Text(TabItemList[idx].title)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.pageIndex === idx? '#006eee':'#888')
    }
  }
}