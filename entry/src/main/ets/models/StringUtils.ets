import util from '@ohos.util';

class StringUtils {
  /**
   * string转Uint8Array
   * @param value
   * @returns
   */
  string2Uint8Array1(value: string): Uint8Array {
    if (!value) return null;
    //
    let textEncoder = new util.TextEncoder();
    //获取点流并发出 UTF-8 字节流 TextEncoder 的所有实例仅支持 UTF-8 编码
    return textEncoder.encodeInto(value)
  }
  /**
   * string转Uint8Array
   * @param value 包含要编码的文本的源字符串
   * @param dest 存储编码结果的Uint8Array对象实例
   * @returns 它返回一个包含读取和写入的两个属性的对象
   */
  string2Uint8Array2(value: string, dest: Uint8Array) {
    if (!value) return null;
    if (!dest) dest = new Uint8Array(value.length);
    let textEncoder = new util.TextEncoder();
    //read：它是一个数值，指定转换为 UTF-8 的字符串字符数。如果 uint8Array 没有足够的空间，这可能小于 src.length(length of source 字符串)。
    //dest：也是一个数值，指定存储在目标 Uint8Array 对象 Array 中的 UTF-8 unicode 的数量。它总是等于阅读。
    textEncoder.encodeIntoUint8Array(value, dest)
    // let result = textEncoder.encodeIntoUint8Array(value, dest)
    // result.read
    // result.written
  }
  /**
   * Uint8Array 转  String
   * @param input
   */
  uint8Array2String(input: Uint8Array) {
    let textDecoder = util.TextDecoder.create("utf-8", { ignoreBOM: true })
    return textDecoder.decodeWithStream(input, { stream: false });
  }
  /**
   * ArrayBuffer 转  String
   * @param input
   * @returns
   */
  arrayBuffer2String(input: ArrayBuffer) {
    return this.uint8Array2String(new Uint8Array(input))
  }
}

export default new StringUtils()