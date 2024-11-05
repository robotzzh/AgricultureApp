/*
 * written in 2024.3.19
 * zhaozihe
 *
 *
 * */

import socket from '@ohos.net.socket';
import util from '@ohos.util';
import LinkedList from '@ohos.util.LinkedList';
import Queue from '@ohos.util.Queue';

export default class TCP{

  local_Ip: string;
  local_port: number;
  remote_Ip: string;
  remote_port: number;
  tcp:socket.TCPSocket;
  cache_info: LinkedList<string>;
  is_connect : boolean;
  cache_send: Queue<string>;

  constructor(local_Ip: string,
              local_port: number,
              remote_Ip: string,
              remote_port: number) {
    this.local_Ip = local_Ip;
    this.local_port = local_port;
    this.remote_Ip = remote_Ip;
    this.remote_port = remote_port;
    this.tcp = socket.constructTCPSocketInstance();
    this.tcp.bind({
      address: this.local_Ip
    })
    this.is_connect = false;
    this.cache_info = new LinkedList<string>();
    this.cache_send = new Queue<string>();

    this.tcp.on('connect',()=>{
      console.info('on connect');
    })

    this.tcp.on('close',()=>{
      console.info('on close');
    })
  }

  static hexStringToArrayBuffer(hexString: string): ArrayBuffer {
    const hex = hexString.replace(/\s/g, ''); // 去除空格
    const bytes = new Uint8Array(hex.length / 2);

    for (let i = 0; i < hex.length; i += 2) {
      bytes[i / 2] = parseInt(hex.substr(i, 2), 16);
    }

    return bytes.buffer;
  }

  static arrayBufferToHexString(buffer: ArrayBuffer): string {
    const view = new DataView(buffer);
    let hexString = '';

    for (let i = 0; i < view.byteLength; i++) {
      let byteValue = view.getUint8(i);
      let hex = byteValue.toString(16).toUpperCase();
      hexString += (hex.length === 1 ? '0' : '') + hex; // 补齐两位十六进制数
    }

    return hexString;
  }

  subscribe(){
    let str:string = "";
    this.tcp.on('message',value =>{
      console.info('on message')
      let info = value.remoteInfo;
      console.info('remote_info:'+info.size)
      let buffer = value.message;
      str = TCP.arrayBufferToHexString(buffer);
      console.info('information: '+ str);
      this.cache_info.add(str.slice(6,6+4));
    })
  }

  join(message:string){
    this.cache_send.add(message);
    //this.cache_send.forEach((value,index)=>{
    //  console.info("Q"+value + "  "+index.toString()+'len'+this.cache_send.length);
    //})
  }

  connect(localIP:string){
    let bindAddress = {
      //TODO:改成本地wifi地址
      address: localIP,
      family: 1
    }
    this.tcp.bind(bindAddress,err=>{
      if(err){
        console.info(this.local_Ip)
        console.info('bind fail:' + err.message);
        return;
      }
      console.info('bind successfully')
      let connect_address = {
        address: this.remote_Ip,
        port: this.remote_port,
        family: 1
      }
      this.tcp.connect({
        address:connect_address,timeout: 6000
      },err=>{
        if(err){
          console.info('connect error:'+ err.message);
          return;
        }
        console.info('connect successfully');
        this.is_connect = true;
      })
    })
  }


  send(){
    let bindAddress = {
      address: this.local_Ip,
      family: 1
    };
    let connectAddress = {
      address: this.remote_Ip,
      port: this.remote_port, // 连接端口，如5678
      family: 1
    };
    /*
    this.cache_send.forEach((value,index)=>{
      console.info("Q"+value + "  "+index.toString()+'len'+this.cache_send.length);
    })
    */
    //let count = 0;
      //console.info(this.cache_send.length.toString() + "  "+ count)
      setTimeout(()=>{
        this.tcp.bind({
          address: this.local_Ip
        })
        console.info("bind success")
      },200)
      setTimeout(()=>{
        this.connect(this.local_Ip);
      },400)
      setTimeout(()=>{
        let message  = this.cache_send.getFirst();
        this.cache_send.pop();
        this.tcp.send({
          data:TCP.hexStringToArrayBuffer(message)
        })
        console.info('send'+ message);
      },800)
      setTimeout(() => {
        this.close();
      }, 1 * 1000)

  }

  close(){
    this.tcp.close((err) => {
      console.log('close socket.')
    });
    this.is_connect = false;
    this.tcp.off('message');
    this.tcp.off('connect');
    this.tcp.off('close');
  }

}