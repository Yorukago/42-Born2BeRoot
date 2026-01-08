# Born2beroot

A project focused on System Administration, Virtualization, and Security.

## Overview
This project involves setting up a **Debian** (or Rocky Linux) server on a Virtual Machine. The goal is to implement strict security rules, manage users/groups, and configure a custom monitoring script—all while following the principles of **LVM** (Logical Volume Management) and **Sudo** policies.

## Configuration
| Feature | Implementation |
| :--- | :--- |
| **Operating System** | Debian 12 (Bookworm) |
| **Partitioning** | LVM with LUKS Encryption |
| **SSH Port** | 4242 |
| **Firewall** | UFW (Uncomplicated Firewall) |
| **User Management** | Password policy & Sudoer groups |
| **Monitoring** | Bash script via Cron every 10 mins |

---

## Security Policies

### Password Policy
Configured in `/etc/login.defs` and `/etc/pam.d/common-password`:
- **Length:** Min. 10 characters.
- **Complexity:** Must contain uppercase, lowercase, and numbers.
- **Expiration:** Every 30 days.
- **History:** Cannot reuse last 7 passwords.

### Sudo Rules
Configured via `visudo` in `/etc/sudoers.d/`:
- Limit to **3 attempts** per password entry.
- Custom error message for wrong passwords.
- All sudo actions archived in `/var/log/sudo/sudo.log`.

---

## Monitoring Script
The `monitoring.sh` script displays system info every 10 minutes on all terminals:
- Architecture & Kernel version.
- Number of physical/virtual processors.
- Current RAM/Disk usage.
- CPU load.
- Last reboot date/time.
- LVM status & TCP connections.
- Number of users logged in.
- I have the monitoring script documented and commented so you can check it out!

---

## 🌐 Bonus: LLMP Stack & WordPress
I completed the bonus part by setting up a fully functional web server environment!

### 🏗️ Services Implemented
* **Lighttpd:** A lightweight, high-performance web server.
* **MariaDB:** A robust relational database management system for WordPress data.
* **PHP:** Processors for dynamic content (fastcgi).
* **WordPress:** A self-hosted CMS site running on the server.

### 🔧 Bonus Commands
| Service | Check Status |
| :--- | :--- |
| **Web Server** | `sudo systemctl status lighttpd` |
| **Database** | `sudo systemctl status mariadb` |
| **PHP** | `sudo systemctl status php -v` |

---

## ⌨️ Useful Commands for Defense
| Action | Command |
| :--- | :--- |
| **Check OS** | `hostnamectl` |
| **Check Groups** | `getent group [group_name]` |
| **Check User Info** | `chage -l [username]` |
| **Check Partitions** | `lsblk` |
| **Check Firewall** | `sudo ufw status numbered` |
| **Check Services** | `sudo systemctl status [service_name]` |
| **Check Sudo Logs** | `cat /var/log/sudo/sudo.log` |

