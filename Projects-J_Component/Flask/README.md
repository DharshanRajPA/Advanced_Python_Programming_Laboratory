# Food Order Web Application

A complete Flask-based food ordering web application with user authentication, restaurant browsing, shopping cart, order management, and admin panel.

## Features

### User Features
- **User Authentication**: Register, login, and logout
- **Restaurant Browsing**: View all available restaurants
- **Menu Browsing**: Browse menu items by restaurant with category filtering
- **Shopping Cart**: Add items to cart, update quantities, remove items
- **Order Placement**: Place orders with delivery address and phone
- **Order History**: View past orders and order details
- **Order Tracking**: Track order status (pending, confirmed, preparing, out for delivery, delivered, cancelled)

### Admin Features
- **Admin Dashboard**: Overview of restaurants and recent orders
- **Restaurant Management**: Add and manage restaurants
- **Menu Management**: Add menu items to restaurants
- **Order Management**: View all orders and update order status

## Installation

1. **Install Basic Dependencies**
   ```bash
   pip install -r requirements.txt
   ```
   
   This installs all core Flask dependencies. The app uses SQLite by default, which requires no additional setup.

2. **Install Production Dependencies (Optional)**
   
   If you need PostgreSQL, Redis, or Gunicorn for production deployment:
   ```bash
   pip install -r requirements-prod.txt
   ```
   
   **Note for Windows users**: If `psycopg2-binary` installation fails, you can:
   - Skip it if you're using SQLite (default)
   - Install PostgreSQL client libraries from https://www.postgresql.org/download/windows/
   - Or use a pre-built wheel: `pip install psycopg2-binary --only-binary :all:`

3. **Run the Application**
   ```bash
   python app.py
   ```

4. **Access the Application**
   - Open your browser and navigate to `http://localhost:5000`

## Default Admin Account

- **Username**: `admin`
- **Password**: `admin123`

**Note**: Change the admin password in production!

## Project Structure

```
Flask/
├── app.py                 # Main Flask application
├── config.py              # Configuration settings
├── models.py              # Database models
├── forms.py               # WTForms form definitions
├── requirements.txt       # Python dependencies
├── templates/             # HTML templates
│   ├── base.html          # Base template
│   ├── index.html         # Home page
│   ├── login.html         # Login page
│   ├── register.html      # Registration page
│   ├── restaurant.html    # Restaurant detail page
│   ├── cart.html          # Shopping cart
│   ├── checkout.html      # Checkout page
│   ├── orders.html        # Order history
│   ├── order_detail.html  # Order details
│   └── admin/             # Admin templates
│       ├── dashboard.html
│       ├── restaurants.html
│       ├── add_restaurant.html
│       ├── menu.html
│       ├── add_menu_item.html
│       └── orders.html
└── static/                # Static files
    ├── css/
    │   └── style.css      # Main stylesheet
    └── js/
        └── main.js        # JavaScript functions
```

## Database Models

- **User**: User accounts with authentication
- **Restaurant**: Restaurant information
- **MenuItem**: Food items in restaurant menus
- **CartItem**: Items in user shopping carts
- **Order**: User orders
- **OrderItem**: Items in each order

## Usage Guide

### For Regular Users

1. **Register/Login**: Create an account or login
2. **Browse Restaurants**: View available restaurants on the home page
3. **View Menu**: Click on a restaurant to see its menu
4. **Add to Cart**: Add items to your shopping cart
5. **Checkout**: Review cart and place order
6. **Track Orders**: View order history and status

### For Administrators

1. **Login as Admin**: Use admin credentials
2. **Add Restaurants**: Go to Admin → Add Restaurant
3. **Add Menu Items**: Go to Admin → Add Menu Item
4. **Manage Orders**: Go to Admin → Manage Orders to update order status

## Technologies Used

- **Flask**: Web framework
- **Flask-SQLAlchemy**: Database ORM
- **Flask-Login**: User session management
- **Flask-WTF**: Form handling and CSRF protection
- **WTForms**: Form validation
- **SQLite**: Database (can be changed to PostgreSQL/MySQL)

## Security Features

- Password hashing using Werkzeug
- CSRF protection with Flask-WTF
- User authentication and authorization
- Admin-only routes protection

## Future Enhancements

- Payment integration
- Real-time order tracking
- Email notifications
- Restaurant ratings and reviews
- Search functionality
- User profiles
- Delivery tracking map
- Multiple payment methods

## License

This project is for educational purposes.

