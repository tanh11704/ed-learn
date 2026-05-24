# Admin Web Deployment

CI/CD cho `admin_web` deploy bản build Vite lên VPS và serve qua Nginx tại `admin.phuocanh.me`.

## GitHub Secrets

Thêm các secrets trong repository GitHub:

| Secret                   | Bắt buộc | Mô tả                                                                    |
| ------------------------ | -------- | ------------------------------------------------------------------------ |
| `VPS_HOST`               | Có       | IP hoặc hostname VPS                                                     |
| `VPS_USERNAME`           | Có       | User SSH deploy                                                          |
| `VPS_SSH_KEY`            | Có       | Private key SSH                                                          |
| `ADMIN_WEB_API_BASE_URL` | Không    | API URL build vào Vite, mặc định `https://api.phuocanh.me/api/v1`        |
| `ADMIN_WEB_DEPLOY_PATH`  | Không    | Thư mục deploy trên VPS, mặc định `$HOME/edlearn/admin_web` của user SSH |

## VPS Setup

Trỏ DNS `A` record của `admin.phuocanh.me` về IP VPS, sau đó chạy trên VPS:

```bash
sudo apt update
sudo apt install -y nginx certbot python3-certbot-nginx
mkdir -p ~/edlearn/admin_web
sudo chown -R www-data:www-data ~/edlearn/admin_web
```

Workflow sẽ deploy file build vào `~/edlearn/admin_web` và tạo symlink `/var/www/admin.phuocanh.me` trỏ tới thư mục này. Cách này giữ source/deploy artifact tập trung trong `~/edlearn`, còn Nginx vẫn dùng path chuẩn dưới `/var/www`.

Copy `deploy/admin_web.nginx.conf` vào Nginx:

```bash
sudo cp deploy/admin_web.nginx.conf /etc/nginx/sites-available/admin.phuocanh.me
sudo ln -s /etc/nginx/sites-available/admin.phuocanh.me /etc/nginx/sites-enabled/admin.phuocanh.me
sudo nginx -t
sudo systemctl reload nginx
```

Cấp SSL:

```bash
sudo certbot --nginx -d admin.phuocanh.me
```

## Deploy

Workflow `.github/workflows/admin-web-ci-cd.yml` chạy khi push lên `main` và có thay đổi trong `admin_web/**`.

Trên pull request, workflow chỉ build để kiểm tra. Trên push vào `main`, workflow build `admin_web/dist`, upload artifact lên VPS, rồi publish vào `ADMIN_WEB_DEPLOY_PATH`.
