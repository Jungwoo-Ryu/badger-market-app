# badger_market

A new Flutter project.

<img width="383" alt="Screenshot 2025-02-23 at 9 28 36 PM" src="https://github.com/user-attachments/assets/778f89a4-50e3-45a2-930e-07098aa48d27" />

<img width="391" alt="Screenshot 2025-02-23 at 9 26 52 PM" src="https://github.com/user-attachments/assets/a8e8ea49-5468-4fcd-8ea4-23d19e23edb3" />

## ERD
```
+------------------+       +------------------+       +--------------------+       +------------------+
|      User        |       |     Product      |       |     ChatRoom       |       |     Message      |
+------------------+       +------------------+       +--------------------+       +------------------+
| user_id (PK)     |<----- | product_id (PK)  |<----- | user_id (PK, FK)   |<----- | message_id (PK)  |
| username (Unique)|       | title            |       | product_id (PK, FK)|       | user_id (FK)     |
| email (Unique)   |       | description      |       | created_at         |       | product_id (FK)  |
| password         |       | price            |       +--------------------+       | sender_id (FK)   |
| created_at       |       | status           |                                    | content          |
+------------------+       | created_at       |                                    | sent_at          |
                           | created_by (FK)  |                                    +------------------+
                           +------------------+
```
# badger-market-app
