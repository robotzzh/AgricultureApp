import distributedKVStore from '@ohos.data.distributedKVStore';

const BUNDLE_NAME = "Agriculture"

let context = getContext(this)
// 数据库对象
let kvManager: distributedKVStore.KVManager | undefined = undefined;
// KVStore数据库
let kvStore: distributedKVStore.SingleKVStore | undefined = undefined;

class DistributedUtil {
  constructor() {
    this.createKeyValueDB();
  }
  async getKvManager(bundleName?: string) {
    const kvStoreConfig: distributedKVStore.KVManagerConfig = {
      context: context,
      bundleName: bundleName || BUNDLE_NAME
    };
    try {
      kvManager = distributedKVStore.createKVManager(kvStoreConfig);
    }
    catch (err) {
      console.error(`error:${err}`)
    }
  }

  // 创建并得到指定类型的KVStore数据库
  async createKeyValueDB(op?: distributedKVStore.Options) {
    if (kvManager === undefined) {
      this.getKvManager();
    }
    try {
      const options: distributedKVStore.Options = {
        // 当数据库文件不存在时是否创建数据库，默认为true
        createIfMissing: true,
        // 设置数据库文件是否加密，默认为false，即不加密
        encrypt: false,
        // 设置数据库文件是否备份，默认为true，即备份
        backup: false,
        // 设置数据库文件是否自动同步。默认为false，即手动同步
        autoSync: true,
        // kvStoreType不填时，默认创建多设备协同数据库
        kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
        // 多设备协同数据库：kvStoreType: distributedKVStore.KVStoreType.DEVICE_COLLABORATION,
        securityLevel: distributedKVStore.SecurityLevel.S1
      };
      kvManager.getKVStore<distributedKVStore.SingleKVStore>('storeId', op || options, (err, store: distributedKVStore.SingleKVStore) => {
        if (err) {
          console.error(`Failed to get KVStore: Code:${err.code},message:${err.message}`);
          return;
        }
        console.info('Succeeded in getting KVStore.');
        kvStore = store;
      });
    } catch (e) {
      console.error(`An unexpected error occurred. Code:${e.code},message:${e.message}`);
    }
    return kvStore;
  }

  // 删除指定键值的数据
  async deleteStoreData(key: string) {
    if (!kvStore) {
      return;
    }

    try {
      kvStore.delete(key, (err) => {
        if (err !== undefined) {
          console.error(`Failed to delete data. Code:${err.code},message:${err.message}`);
          return;
        }
        console.info('Succeeded in deleting data.');
      });
    } catch (e) {
      console.error(`An unexpected error occurred. Code:${e.code},message:${e.message}`);
    }
  }

  // 向键值数据库中插入数据
  async putStoreData(key: string, value: any) {
    if (!key || !value) {
      return
    }

    if(!kvStore) {
      kvStore = await this.createKeyValueDB();
    }

    try {
      kvStore.put(key, value, (err) => {
        if (err !== undefined) {
          console.error(`Failed to put data. Code:${err.code},message:${err.message}`);
          return;
        }
        console.info('Succeeded in putting data.');
      });
    } catch (e) {
      console.error(`An unexpected error occurred. Code:${e.code},message:${e.message}`);
    }
  }

  // 获取指定键的值
  async getStoreData(key: string) {
    if (!key) {
      return
    }

    if(!kvStore) {
      kvStore = await this.createKeyValueDB();
    }

    return new Promise((resolve, reject) => {
      try {
        kvStore.get(key, (err, data) => {
          if (err != undefined) {
            console.error(`Failed to get data. Code:${err.code},message:${err.message}`);
            reject(err)
            return;
          }
          resolve(data)
        });
      } catch (err) {
        reject(err)
        console.error('TAG', `Failed to get value, Cause: ${err}`)
      }
    });
  }
}

export default new DistributedUtil();