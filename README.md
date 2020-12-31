[cover]: https://raw.githubusercontent.com/moleculerjs/moleculer/master/docs/assets/logo.png
[performance1]: https://moleculer.services/docs/0.14/assets/benchmark/benchmark_local.svg
[performance2]: https://moleculer.services/docs/0.14/assets/benchmark/benchmark_remote.svg

> Lưu ý các command không có dấu $, $ là ký hiệu các command phải chạy bằng cửa sổ dòng lệnh

![cover][cover]

Moleculer là một framework trên Node.js, cung cấp nhiều tính năng để xây dựng và quản lý các microservices một cách hiệu quả, đáng tin cậy và linh hoạt.

**Website**: https://moleculer.services

**Tài liệu**: https://moleculer.services/docs

**Repository**: https://github.com/moleculerjs/moleculer

**npm**: https://www.npmjs.com/package/moleculer

## Các tính năng

- Giải pháp dựa trên Promise (hỗ trợ cú pháp async/await)
- Hỗ trợ khái niệm: request-reply
- Hỗ trợ kiến trúc huớng sự kiện với cân bằng tải
- Có thể tích hợp và phát hiện các service có sẵn và linh động
- Cân bằng tải các request và event (hỗ trợ kỹ thuật round-robin, ngẫu nhiên, mức độ sử dụng cpu, độ trễ và phân chia)
- Hệ thống plugin và middleware
- Hỗ trợ việc đánh dấu phiên bản các services
- Hỗ trợ Streams
- Hỗ trợ mixins
- Có sẵn giải pháp Cache (Memory, memoryLRU, redis)
- Hỗ trợ nhiều plugin loggers (Console, file, pino, bunyan, winston, debug, datalog, log4js)
- Hỗ trợ nhiều plugin transporters (TCP, NATS, MQTT, Redis, NATS Streaming, Kafka, AMQP)
- Hỗ trợ nhiều serializers (JSON, Avro, MsgPackm Protocol Buffer, Thrift)
- Hỗ trợ nhiều plugin kiểm tra tham số (validator)
- Hỗ trợ đa services trên một node/server
- Kiến trúc phi-chủ, các node ngang hàng
- Có sẵn các thước đo với reporters (Console, csv, datadog, event, prometheus, statsD)
- Có sẵn tính năng truy vết với exporters (Console, datadog, event, jaeger, zipkin)
- API Gateway, truy cập database và nhiều modules khác nhau...

## Hiệu năng

![hiệu năng 1][performance1]

![hiệu năng 2][performance2]

Xem thêm các kết quả test benchmark tại [đây](https://moleculer.services/docs/0.14/benchmark.html)

## Phát hành

Release thứ **94**

Phiên bản hiện tại: [0.14.11](https://github.com/moleculerjs/moleculer/releases/tag/v0.14.11)

## Cài đặt

### Chuẩn bị

> **Windows**
>
> - Editor (vd: [Visual Studio Code](https://code.visualstudio.com/))
> - Node.js (tốt nhất là một trong các bản [LTS 10 hoặc 12](https://nodejs.org/en/download/releases/))<
> - Docker ([Desktop](https://www.docker.com/get-started), hoặc có thể dùng [ToolBox](https://docs.docker.com/docker-for-windows/docker-toolbox/))<
> - [Docker compose](https://docs.docker.com/compose/install/) (đọc kỹ huớng dẫn cài đặt)<
> - Dùng CMD hoặc PowerShell làm terminal

> **Linux**
>
> - Editor (vd: [Visual Studio Code](https://code.visualstudio.com/))<
> - Node.js (tốt nhất là một trong các bản [LTS 10 hoặc 12](https://nodejs.org/en/download/releases/))<
> - Docker ([Desktop](https://www.docker.com/get-started), hoặc có thể dùng [ToolBox](https://docs.docker.com/docker-for-windows/docker-toolbox/))<
> - [Docker compose](https://docs.docker.com/compose/install/) (đọc kỹ huớng dẫn cài đặt)<
> - Dùng bash/shell/zsh làm terminal

> **MacOS**
>
> - Editor (vd: [Visual Studio Code](https://code.visualstudio.com/))<
> - Node.js (tốt nhất là một trong các bản [LTS 10 hoặc 12](https://nodejs.org/en/download/releases/))<
> - Docker ([Desktop](https://www.docker.com/get-started))<
> - [Docker compose](https://docs.docker.com/compose/install/) (đọc kỹ huớng dẫn cài đặt)
> - Dùng zsh (mặc định) làm terminal

---

Đảm bảo các lệnh sau trả ra kết quả (lưu ý: không nhất thiết phải giống version):

```
$ docker -v
Docker version 20.10.0, build 7287ab3
```

```
$ docker-compose -v
docker-compose version 1.27.4, build 40524192
```

### Thao tác cài đặt Moleculer và khởi chạy 1 project Moleculer bằng boilerplate

1. Cài đặt CLI ở global của môi trường node:

```
$ npm i moleculer-cli -g
```

2. Tạo mới project moleculer với tên: moleculer-demo. Nhấp enter để dùng thiết lập mặc định khi được hỏi

```
$ moleculer init project moleculer-demo
```

3. Di chuyển con trỏ dòng lệnh vào thư mục project

```
$ cd moleculer-demo
```

4. Chạy project

```
$ npm run dev
```

5. Xác nhận hệ thống đã chạy bằng cách truy cập giao diện quản lý tại địa chỉ http://localhost:3000/

# Thực hành

Dùng Moleculer và các công nghệ/công cụ hỗ trợ để xây dựng nhanh một hệ thống bán hàng bằng kiến trúc microservices, đáp ứng các chức năng:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Người dùng là khách hàng:

- Đăng ký tài khoản, đăng nhập, đăng xuất, reset mật khẩu
- Xem hàng hoá
- Thêm hàng vào giỏ hàng
- Thanh toán
- Xem/Huỷ đơn hàng

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Người dùng là người bán hàng:

- Đăng ký, đăng nhập, đăng xuất, reset mật khẩu
- Thêm hàng
- Xem/Sửa/Huỷ đơn hàng

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Yêu cầu kỹ thuật:

- Microservices bằng Moleculer
- Giao diện người dùng cuối nền Web bằng React
- Database SQL: dùng SQL Server 2017 (Docker)
- Database NoSQL và Cache bằng Redis (Docker)
- Phát triển, đóng gói và triển khai các ứng dụng bằng Docker

## Tổ chức thư mục

Workspace được tổ chức như sau:

```
├── frontend
│   ├── apps
│   │   ├── moleshop
│   │   └── adminConsole
│   └── lib
├── backend
│   ├── public
│   ├── src
│   │   ├── aliases
│   │   ├── common
│   │   ├── handlers
│   │   ├── models
│   │   ├── services
│   │   └── utils
│   ├── tests
│   └── docker
│       ├── dev
│       ├── test
│       └── production
├── logs
└── docs
```

## Môi trường và công cụ phát triển phần mềm

> **Windows**
>
> - Editor (vd: [Visual Studio Code](https://code.visualstudio.com/))
> - Node.js (tốt nhất là một trong các bản [LTS 10 hoặc 12](https://nodejs.org/en/download/releases/))<
> - Docker ([Desktop](https://www.docker.com/get-started), hoặc có thể dùng [ToolBox](https://docs.docker.com/docker-for-windows/docker-toolbox/))<
> - [Docker compose](https://docs.docker.com/compose/install/) (đọc kỹ huớng dẫn cài đặt)<
> - Dùng CMD hoặc PowerShell làm terminal

> **Linux**
>
> - Editor (vd: [Visual Studio Code](https://code.visualstudio.com/))<
> - Node.js (tốt nhất là một trong các bản [LTS 10 hoặc 12](https://nodejs.org/en/download/releases/))<
> - Docker ([Desktop](https://www.docker.com/get-started), hoặc có thể dùng [ToolBox](https://docs.docker.com/docker-for-windows/docker-toolbox/))<
> - [Docker compose](https://docs.docker.com/compose/install/) (đọc kỹ huớng dẫn cài đặt)<
> - Dùng bash/shell/zsh làm terminal

> **MacOS**
>
> - Editor (vd: [Visual Studio Code](https://code.visualstudio.com/))<
> - Node.js (tốt nhất là một trong các bản [LTS 10 hoặc 12](https://nodejs.org/en/download/releases/))<
> - Docker ([Desktop](https://www.docker.com/get-started))<
> - [Docker compose](https://docs.docker.com/compose/install/) (đọc kỹ huớng dẫn cài đặt)
> - Dùng zsh (mặc định) làm terminal

## Databases

### SQL Server 2017

Phiên bản image phát hành hiện tại: [2017-latest, 2019-latest, 2017-CU21-ubuntu-16.04, 2019-CU8-ubuntu-16.04](https://hub.docker.com/_/microsoft-mssql-server?tab=description)

VD cách dùng Docker khởi tạo một container SQL Server Developer mà không cần cài đặt native:

```
$ docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=mật_khẩu(!)mạnh' -p 1433:1433 -d mcr.microsoft.com/mssql/server:2017-latest
```

---

Dùng Visual Studio Code để quản lý trực tiếp container SQL Server:

1. Search và cài đặt extension [SQL Server](https://marketplace.visualstudio.com/items?itemName=ms-mssql.mssql)
2. Follow hướng dẫn sử dụng: https://docs.microsoft.com/en-us/sql/tools/visual-studio-code/sql-server-develop-use-vscode?view=sql-server-ver15

Hoặc dùng tool [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-2017) để connect đến container.

### Redis

[Redis](https://redis.io/) là một kho lưu trữ các cấu trúc dữ liệu ngay trên RAM, mã nguồn mở, dùng như database, bộ đệm (cache), hoặc message broker. Redis cung cấp các cấu trúc dữ liệu có sẵn như: string, hash, list, set, sorted set theo range truy vấn, bitmap, hyperloglog, chỉ mục không gian địa lý, và stream

VD cách dùng Docker khởi tạo một container Redis server mà không cần cài đặt native:

```
$ docker run --name some-redis -d redis redis-server --appendonly yes --requirepass mật_khẩu_redis
```

---

Dùng UI Tool để quản lý Redis server. Ví dụ [Redis Desktop Manager](https://rdm.dev/)

1. Cài đặt [RDM](https://rdm.dev/)
2. Kết nối đến container bằng:<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Địa chỉ server: `localhost` (lấy theo địa chỉ của docker, với Docker Desktop là `localhost`, với Docker Toolbox là `192.168.99.100`)<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Mật khẩu: `mật_khẩu_redis`

## Front-End

[React](https://reactjs.org/) là một thư viện JavaScript mã nguồn mở, dùng để xây dựng giao diện người dùng hoặc các thành phần UI.

[Ionic](https://ionicframework.com/) là một bộ công cụ mã nguồn mở dùng javascript để xây dựng các giao diện ứng dụng đa nền tảng và web.

## Back-End

Huớng dẫn theo phong cách Database First

### Thiết kế database

**Models**

**Dump data**

1. Dùng Azure Data Studio, connect vào container SQL Server
2. Mở file script dumpData.sql tại `<project-root>/docs/dumpData.sql`
3. Execute script

### Xây dựng FrontEnd & BackEnd Apps

0. Tạo các thư mục tổ chức theo cấu trúc project FrontEnd & BackEnd

**Declarations**

1. Dùng terminal, di chuyển con trỏ vào thư mục backend

```
cd <project root>/backend
```

2. Khởi tạo app back-end bằng lệnh

```
$ npm init -y
```

3. Cài đặt các thư viện:

```
$ npm install --save moleculer-web nats ioredis moleculer
```

4. Cài đặt các thư viện:

```
$ npm install --save-dev eslint jest jest-cli moleculer-repl
```

5. Thêm các script sau vào khoá `scripts` trong file packages.json

```
"scripts": {
    "dev": "env-cmd -f ./dev.env moleculer-runner --repl --hot --config moleculer.dev.config.js ./src/services/**/*.js",
    "start": "moleculer-runner",
    "cli": "moleculer connect NATS",
    "ci": "jest --watch",
    "test": "jest --coverage",
    "lint": "eslint services",
    "dc:up": "docker-compose up --build -d",
    "dc:logs": "docker-compose logs -f",
    "dc:down": "docker-compose down"
}
```

6. Thêm configs cho jest trong file packages.json:

```
"jest": {
    "coverageDirectory": "../coverage",
    "testEnvironment": "node",
    "rootDir": "./src",
    "roots": [
        "../test"
    ],
    "setUpFiles":[
        "./jest.config.js"
    ]
}
```

7. Cài đặt các thư viện dependencies:

```
$ npm install --save bcryptjs env-cmd helmet jsonwebtoken ms sequelize tedious util
```

8. Cài đặt các thư viện dev-dependencies:

```
$ npm install --save-dev sequelize-auto
```

> Thông tin các thư viện có thể tìm hiểu tại www.npmjs.com

9. Tạo các thư mục theo cấu trúc tổ chức project

**Gateway API**

Module `moleculer-web` là service Gateway API chính thức, dùng để public các RESTful APIs cho các services.

> **Ưu điểm**
>
> - Hỗ trợ HTTP và HTTPS
> - Hỗ trợ serve file tĩnh
> - Đa routes
> - Hỗ trợ các middlewares dạng kết nối ở level global, route và alias
> - Gán mật danh
> - Cung cấp danh sách trắng
> - Hỗ trợ nhiều parsers
> - CORS
> - Hỗ trợ giới hạn rate
> - Có các hook before và after mỗi lần call
> - Hỗ trợ buffer và stream
> - Hỗ trợ chạy ở chế độ middleware, tương tác với các thư viện khởi tao server khác như Express...

1. Cài đặt

```
$ npm install --save moleculer-web
```

2. Dùng

```
const { ServiceBroker } = require("moleculer");
const ApiService = require("moleculer-web");

const broker = new ServiceBroker();

// Load API Gateway
broker.createService(ApiService);

// Start server
broker.start();
```

3. Tài liệu chi tiết & APIs: [modeluler-web](https://moleculer.services/docs/0.14/moleculer-web.html)

**Generate models/data transfer object layer cho services**

1. Di chuyển con trỏ vào backend, chạy lệnh:

```
sequelize-auto \
    -h <địa chỉ host> \
    -d <tên database> \
    -u <tài khoản super admin của database server> \
    -x <mật khẩu tài khoản sa> \
    -p <port> \
    -e mssql \
    -o "./src/models"
```

vd:

```
sequelize-auto \
    -h localhost \
    -d Moleshop \
    -u sa \
    -x Password789 \
    -p 1433 \
    -e mssql \
    -o "./src/models"
```

Dùng sequelize để tương tác với database SQL service

```
const { Sequelize } = require("sequelize");

const sequelize = new Sequelize(
    process.env.DB_MAIN_NAME,
    process.env.DB_MAIN_USERNAME,
    process.env.DB_MAIN_PWD,
    {
        dialect: "mssql",
        dialectOptions: {
            options: {
                encrypt: true,
                loginTimeout: 30,
                validateBulkLoadParameters: true,
            },
        },
        pool: {
            max: 5,
            min: 0,
            acquire: 30000,
            idle: 10000,
        },
    }
);
```

Sequelize yêu cầu các khai báo Models tại lớp logic, các Models này dễ dàng có được bằng cách sinh tự động ở trên.

```

const models = require("../models/init-models")(sequelize);

class Database {
	constructor() {
		this.adapter = new Sequelize(
			process.env.DB_MAIN_NAME,
			process.env.DB_MAIN_USERNAME,
			process.env.DB_MAIN_PWD,
			{
				dialect: "mssql",
			}
		);
		this.models = models;
	}
}

module.exports = new Database();
```

**Services :: User**

Service đại diện cho một microservice trong Moleculer. Trong service, ta có thể định nghĩa các action và subscript đến các sự kiện. Để tạo một service, ta phải khai báo schema cho nó.

Mỗi service schema có một số field thuờng dùng sau:

- `name`: tên của service, định danh luôn route đến service
- `version`: phiên bản của service, phân biệt các service cùng tên nhưng khác phiên bản
- `settings`: thiết lập nội tại của service
- `actions`: các action, đồng thời cũng là các API được public ra ngoài
- `methods`: giống như các action, nhưng chỉ có thể được gọi nội bộ, không public ra ngoài
- `events`: định nghĩa các event để subscribe đến

Chi tiết tài liệu mô tả Service và APIs xem tại [đây](https://moleculer.services/docs/0.14/services.html)

Ví dụ Service User:

Dùng để phục vụ việc đăng ký, xác thực người dùng, truy xuất và cập nhật profile.

Các action yêu cầu:

- Sign Up
- Sign In
- Sign Out
- Get own profile
- Update own profile
- Get any profile
- Update any profile

1. Khai báo service schema

vd:

```
/**
 * Khai báo cơ bản Service User
 */
"use strict";

/**
 * @typedef {import('moleculer').Context} Context Moleculer's Context
 */

module.exports = {
  name: "user",
  version: process.env.SERVICE_USER_VERSION,
  metadata: {
    scalable: true,
    priority: 5,
  },
  actions: {},
  hooks: {},
  methods: {},
};

```

2. Định nghĩa các action logic:

Mỗi action có một số fields chính như `rest`, `params`, `handler`... Trong đó `rest` cho phép định nghĩa cụ thể phương thức HTTP và route của action, `params` dùng để khai báo và validate giá trị các tham số của action, `handler` chứa khối logic của action, `handler` là một function object, nhận vào tham số là context của request.

vd:

```
signout: {
    rest: {
        method: "POST",
        path: "/signout",
    },
    params: {
        all: { type: "boolean" },
    },
    async handler(ctx) {
        const { action, params, meta, ...rest } = ctx;
        const { all } = params;

        if (all) {
            authHandler.deleteAllAuthInfoByUserID(meta.user.id);
        } else {
            authHandler.deleteAuthInfoByUserID(meta.user.id);
        }

        return true;
    },
}
```

3. Moleculer còn cung cấp các `hooks` cho phép dễ dàng can thiệp vào lifecyle của services và actions.

`hooks` cung cấp 3 dạng: `before`, `after` và `error`. Mỗi `hook` là 1 string gọi đến tên của `method`, 1 function object hoặc 1 array các function objects.

vd: để request gọi đến /sigout được xem là hợp lệ thì, request đó đã được authenticated (tức là user phải logged in rồi), ta có thể dùng `hooks` để can thiệp vào chu kỳ ngay trước khi gọi action và kiếm tra request có chứa thông tin xác thực người dùng hay không

```
hooks: {
    before: {
        signout: "isAuthenticated",
        getProfile: [
            function isAuthenticated(ctx) {
                return this.isAuthenticated(ctx);
            },
            function isValid2performAction(ctx) {
                return this.isValid2performAction(ctx, undefined, [
                    "READ:OWN_PROFILE",
                    "READ:OWN_ORDERS",
                ]);
            },
        ],
    },
}
```

4. `methods` là nơi tập trung các phương thức, hàm & logc chung, tái sử dụng nhiều lần và không cần thiết phải public ra bên ngoài service

vd:

```
methods: {
    isAuthenticated: authHandler.isAuthenticated,
    isValid2performAction: authHandler.isValid2performAction,
    refinedUserObject(user) {
        const refined = { ...user };

        delete refined.password;
        delete refined.createdAt;
        delete refined.updatedAt;
        delete refined.Assignments;

        const allRoles = user.Assignments.map((x) => x.Role.name);
        const allPermission = user.Assignments.reduce((pre, curr) => {
            const permissions = curr.Role.Permissions.map((x) => x.name);
            pre = [...pre, ...permissions];
            return pre;
        }, []);

        refined["allRoles"] = allRoles;
        refined["allPermissions"] = allPermission;

        return refined;
    },
},
```

### Kiểm thử

[Jest](https://jestjs.io/) là bộ framework kiểm thử bằng Javascript được duy trì bởi Facebook, trọng tâm là sự đơn giản.

Các unit tests được tập trung tại thư mục <project-root>/backend/tests

Tập hợp các test case được định nghĩa bên trong `describe`, mỗi test case được khai báo bằng `it()`, đối số là một callback function. Jest cung cấp nhiều hàm cho phép kiểm tra các kết quả đầu ra mong muốn, bao gồm cả kiểu dữ liệu và giá trị.

Ngoài ra Jest hỗ trợ nhiều `hooks`, `mocks`... cho phép can thiệp vào môi trường của test case.

vd:
```
describe("Unit Test 'user' service", () => {
	let broker = new ServiceBroker({ logger: false });
	broker.createService(UserService);

	beforeAll(() => broker.start());
	afterAll(() => broker.stop());

	testCases["v1.user.signin"].forEach((c) => {
		it(c.description, async () => {
			const { input, expect: expectation } = c;

			if (expectation == true) {
				const res = await broker.call("v1.user.signin", input);

				expect(res).not.toBeNull();
				expect(res.length).toBeGreaterThan(1);
			} else {
				const [code, message] = expectation.split("::");
				const error = new MoleculerError(message, code);
				try {
					await broker.call("v1.user.signin", input);
				} catch (err) {
					expect(err).toBeInstanceOf(MoleculerError);
					expect(`${err.code}::${err.type}`).toBe(expectation);
				}
			}
		});
	});
});

```
