import relationalStore from '@ohos.data.relationalStore';

const DB_NAME = "Agriculture.db"

let context = getContext(this)
let store: relationalStore.RdbStore | undefined = undefined;

class RelationalUtil {
  async getRdbStoreConfig(dbName?: string, config?: relationalStore.StoreConfig) {
    const STORE_CONFIG: relationalStore.StoreConfig = config || {
      // 数据库文件名
      name: dbName || DB_NAME,
      // 数据库安全级别
      securityLevel: relationalStore.SecurityLevel.S1,
      // 可选参数，指定数据库是否加密，默认不加密
      encrypt: false,
    };

    return STORE_CONFIG;
  }

  // 创建并得到指定类型的KVStore数据库
  async createDatabaseTable(sqlCreateTable: string) {
    const STORE_CONFIG = await this.getRdbStoreConfig();
    relationalStore.getRdbStore(context, STORE_CONFIG, (err, rdbStore: relationalStore.RdbStore) => {
      if (err) {
        console.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info('Succeeded in getting RdbStore.');

      // 当数据库创建时，数据库默认版本为0
      store = rdbStore;
      store.executeSql(sqlCreateTable); // 创建数据表
    })
  }

  // 删除数据库
  async deleteDB(dbName: string = DB_NAME) {
    relationalStore.deleteRdbStore(context, dbName, (err) => {
      if (err) {
        console.error(`Failed to delete RdbStore. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info('Succeeded in deleting RdbStore.');
    });
  }

  // 向数据库中插入数据
  async insertDatas(tableName: string, valueBucket) {
    if (store != undefined) {
      (store as relationalStore.RdbStore).insert(tableName, valueBucket, (err, rowId: number) => {
        if (err) {
          console.error(`Failed to insert data. Code:${err.code}, message:${err.message}`);
          return;
        }
        console.info(`Succeeded in inserting data. rowId:${rowId}`);
      })
    }
  }

  // 对数据进行修改
  async updateDatas(tableName: string, valueBucket, key, val) {
    let predicates = new relationalStore.RdbPredicates(tableName); // 创建表tableName的predicates
    predicates.equalTo(key, val); // 匹配表tableName中key为val的字段
    if (store != undefined) {
      (store as relationalStore.RdbStore).update(valueBucket, predicates, (err, rowId: number) => {
        if (err) {
          console.error(`Failed to insert data. Code:${err.code}, message:${err.message}`);
          return;
        }
        console.info(`Succeeded in inserting data. rowId:${rowId}`);
      })
    }
  }

  //根据谓词指定的查询条件查找数据
  async getDatas(tableName: string, atomArr: Array<string>, key: string, val: string | number) {
    let predicates = new relationalStore.RdbPredicates(tableName);
    predicates.equalTo(key, val);
    if (store != undefined) {
      return new Promise((resolve, reject) => {
        (store as relationalStore.RdbStore).query(predicates, atomArr, (err, resultSet) => {
          if (err) {
            console.error(`Failed to query data. Code:${err.code}, message:${err.message}`);
            reject(err);
            return;
          }
          resolve(resultSet);
          console.info(`ResultSet column names: ${resultSet.columnNames}, column count: ${resultSet.columnCount}`);
        })
      })
    }
  }
}

export default new RelationalUtil();