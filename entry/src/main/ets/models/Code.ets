/* 01 03 00 00 00 01 84 0A 读取含水量
01 03 00 01 00 01 D5 CA 只读取温度
01 03 00 02 00 01 25 CA 读取电导率
01 03 00 03 00 01 74 0A 读取PH
01 03 00 04 00 01 C5 CB 读取K
01 03 00 05 00 01 94 0B 读取P
01 03 00 06 00 01 64 0B 读取K
01 03 00 07 00 01 35 CB 读取盐度
01 03 00 08 00 01 05 C8 读取总溶解固体

01 03 02 00 2A 39 9B 响应
00 2A 读取含水量 扩大十倍
01 03 02 00 F9 78 06
00 F9 读取温度 扩大十倍
01 03 02 00 00 B8 44
00 00 读取电导值
01 03 02 00 1E 38 4C
00 1E 读取PH值 扩大十倍
01 03 02 00 00 B8 44
读取氮磷钾*/
export interface Item{
    destination : number;
    code: string;
    name: string;
}

export enum CodeID{
  temperature,
  humidity,
  co2,
  lumination,
  soilHumidity,
  N ,
  P,
  K,
  PH,
  conductivity,
}


// 目前实现阅读的传感器数据
export const CodeLIST: Item[] = [
  {
    destination: CodeID.temperature,
    code: "01 03 00 01 00 01 D5 CA",
    name: "temperature"
  },
  {
    destination: CodeID.humidity,
    code : "01 03 00 00 00 01 84 0A",
    name: "humidity"
  },

  {
    destination: CodeID.co2,
    code : "",
    name: 'co2',
  },

  {
    destination: CodeID.lumination,
    code : "",
    name: 'lumination',
  },

  {
    destination: CodeID.soilHumidity,
    code : "",
    name: 'soilHumidity'
  },

  {
    destination: CodeID.N,
    code : "01 03 00 06 00 01 64 0B",
    name : "N"
  },

  {
    destination: CodeID.P,
    code : "01 03 00 05 00 01 94 0B",
    name : "P",
  },

  {
    destination: CodeID.K,
    code : "01 03 00 04 00 01 C5 CB",
    name: "K",
  },
  {
    destination: CodeID.conductivity,
    code : "01 03 00 02 00 01 25 CA",
    name: "conductivity",
  },
]
