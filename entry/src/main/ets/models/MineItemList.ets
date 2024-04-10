export interface InfoItem{
  id: string;
  title: string;
  icon?: Resource;
  path: string;
}

export const MineItemList: InfoItem[] = [
  {
    id:'1',
    title:'个人资料',
    icon:$r("app.media.key"),
    path: 'pages/informationPage'
  },

  {
    id:'2',
    title:'账号与安全',
    icon:$r("app.media.key"),
    path: 'pages/SecurityPage'
  },

  {
    id:'3',
    title:'检查更新',
    icon:$r("app.media.key"),
    path: 'pages/UpdatePage'
  },

  {
    id:'4',
    title:'关于',
    icon:$r("app.media.key"),
    path: 'pages/RegardingPage'
  },

]
