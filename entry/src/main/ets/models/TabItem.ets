export interface TabItem{
  icon:Resource;
  icon_select:Resource;
  title: string;
  id: number;
}

export enum TabID{
  HOME,
  WATER_PLAN,
  MINE
}

export const TabItemList: TabItem[] = [
  {
    icon:$r('app.media.home1'),
    icon_select: $r('app.media.icon'),
    title: '主页',
    id : TabID.HOME
  },
  {
    icon:$r('app.media.home1'),
    icon_select: $r('app.media.icon'),
    title: '灌溉计划',
    id : TabID.WATER_PLAN
  },
  {
    icon:$r('app.media.home1'),
    icon_select: $r('app.media.icon'),
    title: '我的',
    id : TabID.MINE
  },
]
