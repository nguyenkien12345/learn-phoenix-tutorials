+ Cài đặt phoenix: 
- mix phx.new tutorials --no-install --app tutorials --database postgres --no-live --no-assets --no-html --no-dashboard --no-mailer --binary-id

+ Thêm thư viện trong file mix.exs (defp deps do end)

+ Cài đặt các thư viện trong phoenix
- mix deps.get

+ Cài đặt database
- mix ecto.create

+ Truy cập vào trong database của chúng ta (Truy cập vào Terminal trong Docker)
- psql -U nguyentrungkien tutorials_dev
- mysql -uroot -p

+ Khởi chạy dự án
- mix phx.server

- mix phx.gen.json cho phép bạn tạo các thành phần quan trọng của một API bao gồm: Resource, Migrations, Model, Controller, Views, Serializers
- mix phx.gen.json Accounts(Đây là tên module => Tương tác trực tiếp với cơ sở dữ liệu) Account(Đây là tên Schema) accounts(Đây là tên bảng) email:string hash_password:string(Các field trong bảng accounts)
- mix phx.gen.json Accounts Account accounts email:string hash_password:string
- Sau khi chạy lệnh trên xong thì trong lib/tutorials sẽ xuất hiện 1 folder mới là accounts chứa account.ex (Đây chính là file schema. Định nghĩa các relationship trong đây, validate data trước khi lưu, cho phép lưu trữ những field nào vào table) và 1 file accounts.ex 
(Đây chính là file module => Tương tác trực tiếp với cơ sở dữ liệu). Trong priv/repo/migrations sẽ xuất hiện 1 migration liên quan đến create_accounts
- mix phx.gen.json Users User users account_id:references:accounts full_name:string gender:string biography:text

+ Các migration sẽ nằm trong priv/repo/migrations

+ Thực thi các migration
mix ecto.migrate

+ Add new Account into table
- Tutorials.Accounts.create_account(%{email: "nguyentrungkien@gmail.com", hash_password: "nguyentrungkien"})

+ Cấu hình guardian, logger trong config/config.exs

+ Câu lệnh tạo ra secret-key với guard: mix guardian.gen.secret

+ Thực hiện tạo migration với Guardian.DB: mix guardian.db.gen.migration