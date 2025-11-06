from flask import Flask, render_template, request, redirect, url_for, flash, jsonify
from flask_login import LoginManager, login_user, logout_user, login_required, current_user
from models import db, User, Restaurant, MenuItem, CartItem, Order, OrderItem
from forms import LoginForm, RegisterForm, RestaurantForm, MenuItemForm, OrderForm
from config import Config
from datetime import datetime
import time
import os

app = Flask(__name__)
app.config.from_object(Config)

db.init_app(app)
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'
login_manager.login_message = 'Please log in to access this page.'

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

# Health check endpoint
@app.route('/health')
def health_check():
    """Health check endpoint for Docker and load balancers"""
    try:
        # Check database connection
        db.session.execute(db.text('SELECT 1'))
        db_status = 'healthy'
    except Exception as e:
        db_status = f'unhealthy: {str(e)}'
    
    return jsonify({
        'status': 'healthy' if db_status == 'healthy' else 'degraded',
        'database': db_status,
        'timestamp': datetime.utcnow().isoformat()
    }), 200 if db_status == 'healthy' else 503

# Seed sample data
def seed_sample_data():
    """Add sample restaurants and menu items to the database"""
    # Only seed if no restaurants exist
    if Restaurant.query.count() > 0:
        return
    
    # Sample restaurants data
    restaurants_data = [
        {
            'name': 'Pizza Paradise',
            'description': 'Authentic Italian pizzas with fresh ingredients and traditional recipes. Family-owned since 1995.',
            'address': '123 Main Street, Downtown',
            'phone': '+1 (555) 123-4567',
            'image_url': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&h=300&fit=crop',
            'menu_items': [
                {'name': 'Margherita Pizza', 'description': 'Classic pizza with fresh mozzarella, tomato sauce, and basil', 'price': 12.99, 'category': 'Pizza', 'image_url': 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=300&h=200&fit=crop'},
                {'name': 'Pepperoni Pizza', 'description': 'Traditional pepperoni with mozzarella cheese', 'price': 14.99, 'category': 'Pizza', 'image_url': 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=300&h=200&fit=crop'},
                {'name': 'Hawaiian Pizza', 'description': 'Ham, pineapple, and mozzarella cheese', 'price': 15.99, 'category': 'Pizza', 'image_url': 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=300&h=200&fit=crop'},
                {'name': 'Garlic Bread', 'description': 'Fresh baked bread with garlic butter', 'price': 5.99, 'category': 'Sides', 'image_url': 'https://images.unsplash.com/photo-1572441713132-51c75654db73?w=300&h=200&fit=crop'},
                {'name': 'Caesar Salad', 'description': 'Fresh romaine lettuce with Caesar dressing', 'price': 8.99, 'category': 'Salads', 'image_url': 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=300&h=200&fit=crop'},
            ]
        },
        {
            'name': 'Burger House',
            'description': 'Gourmet burgers made with premium beef and fresh ingredients. Best burgers in town!',
            'address': '456 Oak Avenue, Midtown',
            'phone': '+1 (555) 234-5678',
            'image_url': 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=400&h=300&fit=crop',
            'menu_items': [
                {'name': 'Classic Cheeseburger', 'description': 'Beef patty, cheese, lettuce, tomato, onion, pickles', 'price': 9.99, 'category': 'Burgers', 'image_url': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300&h=200&fit=crop'},
                {'name': 'Bacon BBQ Burger', 'description': 'Beef patty, bacon, BBQ sauce, cheddar cheese, onion rings', 'price': 12.99, 'category': 'Burgers', 'image_url': 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=300&h=200&fit=crop'},
                {'name': 'Veggie Burger', 'description': 'Plant-based patty with fresh vegetables', 'price': 10.99, 'category': 'Burgers', 'image_url': 'https://images.unsplash.com/photo-1525059696034-4967a7290025?w=300&h=200&fit=crop'},
                {'name': 'French Fries', 'description': 'Crispy golden fries with your choice of seasoning', 'price': 4.99, 'category': 'Sides', 'image_url': 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=300&h=200&fit=crop'},
                {'name': 'Onion Rings', 'description': 'Beer-battered onion rings', 'price': 5.99, 'category': 'Sides', 'image_url': 'https://images.unsplash.com/photo-1551218808-94e220e084d2?w=300&h=200&fit=crop'},
                {'name': 'Chocolate Milkshake', 'description': 'Rich chocolate milkshake with whipped cream', 'price': 6.99, 'category': 'Drinks', 'image_url': 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=300&h=200&fit=crop'},
            ]
        },
        {
            'name': 'Sushi Master',
            'description': 'Fresh sushi and Japanese cuisine. Master chefs prepare authentic dishes daily.',
            'address': '789 Cherry Lane, Uptown',
            'phone': '+1 (555) 345-6789',
            'image_url': 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400&h=300&fit=crop',
            'menu_items': [
                {'name': 'Salmon Sashimi', 'description': 'Fresh Atlantic salmon, 6 pieces', 'price': 16.99, 'category': 'Sashimi', 'image_url': 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=300&h=200&fit=crop'},
                {'name': 'California Roll', 'description': 'Crab, avocado, cucumber, 8 pieces', 'price': 8.99, 'category': 'Rolls', 'image_url': 'https://images.unsplash.com/photo-1611143669185-af224c5e3252?w=300&h=200&fit=crop'},
                {'name': 'Dragon Roll', 'description': 'Eel, cucumber, avocado, eel sauce, 8 pieces', 'price': 14.99, 'category': 'Rolls', 'image_url': 'https://images.unsplash.com/photo-1553621042-f6e147245754?w=300&h=200&fit=crop'},
                {'name': 'Miso Soup', 'description': 'Traditional Japanese miso soup with tofu and seaweed', 'price': 4.99, 'category': 'Soups', 'image_url': 'https://images.unsplash.com/photo-1615874959471-d37d43e89acc?w=300&h=200&fit=crop'},
                {'name': 'Edamame', 'description': 'Steamed soybeans with sea salt', 'price': 5.99, 'category': 'Appetizers', 'image_url': 'https://images.unsplash.com/photo-1596797038530-2c107229654b?w=300&h=200&fit=crop'},
                {'name': 'Green Tea', 'description': 'Traditional Japanese green tea', 'price': 2.99, 'category': 'Drinks', 'image_url': 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=300&h=200&fit=crop'},
            ]
        },
        {
            'name': 'Taco Fiesta',
            'description': 'Authentic Mexican street tacos and traditional dishes. Spice up your day!',
            'address': '321 Elm Street, Riverside',
            'phone': '+1 (555) 456-7890',
            'image_url': 'https://images.unsplash.com/photo-1565299585323-38174c3c0a5a?w=400&h=300&fit=crop',
            'menu_items': [
                {'name': 'Beef Tacos', 'description': 'Three soft shell tacos with seasoned beef, lettuce, cheese, and salsa', 'price': 10.99, 'category': 'Tacos', 'image_url': 'https://images.unsplash.com/photo-1565299585323-38174c3c0a5a?w=300&h=200&fit=crop'},
                {'name': 'Chicken Tacos', 'description': 'Three soft shell tacos with grilled chicken, pico de gallo, and avocado', 'price': 10.99, 'category': 'Tacos', 'image_url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=300&h=200&fit=crop'},
                {'name': 'Fish Tacos', 'description': 'Three soft shell tacos with beer-battered fish, cabbage slaw, and chipotle sauce', 'price': 12.99, 'category': 'Tacos', 'image_url': 'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=300&h=200&fit=crop'},
                {'name': 'Guacamole & Chips', 'description': 'Fresh homemade guacamole with crispy tortilla chips', 'price': 7.99, 'category': 'Appetizers', 'image_url': 'https://images.unsplash.com/photo-1534939561126-855b8675edd7?w=300&h=200&fit=crop'},
                {'name': 'Quesadilla', 'description': 'Flour tortilla with melted cheese, served with sour cream and salsa', 'price': 8.99, 'category': 'Main Dishes', 'image_url': 'https://images.unsplash.com/photo-1618040996337-56904b7850b9?w=300&h=200&fit=crop'},
                {'name': 'Horchata', 'description': 'Traditional Mexican rice drink with cinnamon', 'price': 4.99, 'category': 'Drinks', 'image_url': 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=300&h=200&fit=crop'},
            ]
        },
        {
            'name': 'Sweet Dreams Bakery',
            'description': 'Fresh baked goods, pastries, and desserts. Made fresh daily with love.',
            'address': '654 Maple Drive, Park District',
            'phone': '+1 (555) 567-8901',
            'image_url': 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400&h=300&fit=crop',
            'menu_items': [
                {'name': 'Chocolate Chip Cookies', 'description': 'Fresh baked cookies with premium chocolate chips, 6 pieces', 'price': 6.99, 'category': 'Cookies', 'image_url': 'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=300&h=200&fit=crop'},
                {'name': 'Blueberry Muffin', 'description': 'Large muffin with fresh blueberries', 'price': 4.99, 'category': 'Muffins', 'image_url': 'https://images.unsplash.com/photo-1607958996343-b5e88169055f?w=300&h=200&fit=crop'},
                {'name': 'Croissant', 'description': 'Buttery, flaky French croissant', 'price': 3.99, 'category': 'Pastries', 'image_url': 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=300&h=200&fit=crop'},
                {'name': 'Cheesecake Slice', 'description': 'New York style cheesecake with berry topping', 'price': 7.99, 'category': 'Desserts', 'image_url': 'https://images.unsplash.com/photo-1524351199678-941a58a3df50?w=300&h=200&fit=crop'},
                {'name': 'Cappuccino', 'description': 'Espresso with steamed milk and foam', 'price': 4.99, 'category': 'Coffee', 'image_url': 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=300&h=200&fit=crop'},
                {'name': 'Latte', 'description': 'Espresso with steamed milk', 'price': 4.99, 'category': 'Coffee', 'image_url': 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=300&h=200&fit=crop'},
            ]
        },
        {
            'name': 'Noodle Express',
            'description': 'Fast and delicious Asian noodles. Perfect for a quick lunch or dinner.',
            'address': '987 Pine Street, Business District',
            'phone': '+1 (555) 678-9012',
            'image_url': 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400&h=300&fit=crop',
            'menu_items': [
                {'name': 'Chicken Ramen', 'description': 'Rich chicken broth with ramen noodles, egg, and vegetables', 'price': 11.99, 'category': 'Ramen', 'image_url': 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=300&h=200&fit=crop'},
                {'name': 'Beef Lo Mein', 'description': 'Stir-fried noodles with beef and vegetables', 'price': 12.99, 'category': 'Noodles', 'image_url': 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=300&h=200&fit=crop'},
                {'name': 'Pad Thai', 'description': 'Thai stir-fried noodles with shrimp, tofu, and peanuts', 'price': 13.99, 'category': 'Noodles', 'image_url': 'https://images.unsplash.com/photo-1559314809-0d1550147b98?w=300&h=200&fit=crop'},
                {'name': 'Spring Rolls', 'description': 'Crispy vegetable spring rolls with sweet and sour sauce, 4 pieces', 'price': 6.99, 'category': 'Appetizers', 'image_url': 'https://images.unsplash.com/photo-1529692236671-f1f6cf9683ba?w=300&h=200&fit=crop'},
                {'name': 'Wonton Soup', 'description': 'Pork and shrimp wontons in clear broth', 'price': 7.99, 'category': 'Soups', 'image_url': 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=300&h=200&fit=crop'},
                {'name': 'Jasmine Tea', 'description': 'Fragrant jasmine green tea', 'price': 2.99, 'category': 'Drinks', 'image_url': 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=300&h=200&fit=crop'},
            ]
        }
    ]
    
    # Add restaurants and their menu items
    for rest_data in restaurants_data:
        restaurant = Restaurant(
            name=rest_data['name'],
            description=rest_data['description'],
            address=rest_data['address'],
            phone=rest_data['phone'],
            image_url=rest_data['image_url'],
            is_active=True
        )
        db.session.add(restaurant)
        db.session.flush()  # Get the restaurant ID
        
        # Add menu items for this restaurant
        for item_data in rest_data['menu_items']:
            menu_item = MenuItem(
                name=item_data['name'],
                description=item_data['description'],
                price=item_data['price'],
                category=item_data['category'],
                image_url=item_data['image_url'],
                restaurant_id=restaurant.id,
                is_available=True
            )
            db.session.add(menu_item)
        
        db.session.commit()
    
    print("Sample data seeded successfully!")

# Initialize database with retry logic for containerized environments
def init_db():
    """Initialize database with retry logic for container startup"""
    max_retries = 30
    retry_delay = 2
    
    for attempt in range(max_retries):
        try:
            with app.app_context():
                db.create_all()
                # Create admin user if it doesn't exist
                if not User.query.filter_by(username='admin').first():
                    admin = User(username='admin', email='admin@foodapp.com')
                    admin.set_password('admin123')
                    admin.is_admin = True
                    db.session.add(admin)
                    db.session.commit()
                
                # Seed sample data if database is empty
                seed_sample_data()
                
                print("Database initialized successfully")
                return True
        except Exception as e:
            if attempt < max_retries - 1:
                print(f"Database initialization attempt {attempt + 1} failed: {e}. Retrying in {retry_delay} seconds...")
                time.sleep(retry_delay)
            else:
                print(f"Failed to initialize database after {max_retries} attempts: {e}")
                raise
    return False

# Initialize database on startup
if os.environ.get('INIT_DB', 'true').lower() == 'true':
    init_db()

# Home page
@app.route('/')
def index():
    restaurants = Restaurant.query.filter_by(is_active=True).all()
    return render_template('index.html', restaurants=restaurants)

# Authentication routes
@app.route('/login', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('index'))
    
    form = LoginForm()
    if form.validate_on_submit():
        user = User.query.filter_by(username=form.username.data).first()
        if user and user.check_password(form.password.data):
            login_user(user)
            flash('Login successful!', 'success')
            next_page = request.args.get('next')
            return redirect(next_page) if next_page else redirect(url_for('index'))
        else:
            flash('Invalid username or password', 'error')
    return render_template('login.html', form=form)

@app.route('/register', methods=['GET', 'POST'])
def register():
    if current_user.is_authenticated:
        return redirect(url_for('index'))
    
    form = RegisterForm()
    if form.validate_on_submit():
        if User.query.filter_by(username=form.username.data).first():
            flash('Username already exists', 'error')
        elif User.query.filter_by(email=form.email.data).first():
            flash('Email already registered', 'error')
        else:
            user = User(username=form.username.data, email=form.email.data)
            user.set_password(form.password.data)
            db.session.add(user)
            db.session.commit()
            flash('Registration successful! Please log in.', 'success')
            return redirect(url_for('login'))
    return render_template('register.html', form=form)

@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash('You have been logged out', 'info')
    return redirect(url_for('index'))

# Restaurant and menu routes
@app.route('/restaurant/<int:restaurant_id>')
def restaurant_detail(restaurant_id):
    restaurant = Restaurant.query.get_or_404(restaurant_id)
    menu_items = MenuItem.query.filter_by(restaurant_id=restaurant_id, is_available=True).all()
    categories = db.session.query(MenuItem.category).filter_by(restaurant_id=restaurant_id).distinct().all()
    categories = [cat[0] for cat in categories if cat[0]]
    return render_template('restaurant.html', restaurant=restaurant, menu_items=menu_items, categories=categories)

# Cart routes
@app.route('/cart')
@login_required
def cart():
    cart_items = CartItem.query.filter_by(user_id=current_user.id).all()
    total = sum(item.menu_item.price * item.quantity for item in cart_items)
    return render_template('cart.html', cart_items=cart_items, total=total)

@app.route('/add_to_cart/<int:item_id>', methods=['POST'])
@login_required
def add_to_cart(item_id):
    menu_item = MenuItem.query.get_or_404(item_id)
    if not menu_item.is_available:
        flash('Item is not available', 'error')
        return redirect(url_for('restaurant_detail', restaurant_id=menu_item.restaurant_id))
    
    cart_item = CartItem.query.filter_by(user_id=current_user.id, menu_item_id=item_id).first()
    if cart_item:
        cart_item.quantity += 1
    else:
        cart_item = CartItem(user_id=current_user.id, menu_item_id=item_id, quantity=1)
        db.session.add(cart_item)
    
    db.session.commit()
    flash(f'{menu_item.name} added to cart!', 'success')
    return redirect(url_for('restaurant_detail', restaurant_id=menu_item.restaurant_id))

@app.route('/update_cart/<int:cart_item_id>', methods=['POST'])
@login_required
def update_cart(cart_item_id):
    cart_item = CartItem.query.get_or_404(cart_item_id)
    if cart_item.user_id != current_user.id:
        flash('Unauthorized', 'error')
        return redirect(url_for('cart'))
    
    quantity = int(request.form.get('quantity', 1))
    if quantity <= 0:
        db.session.delete(cart_item)
    else:
        cart_item.quantity = quantity
    db.session.commit()
    return redirect(url_for('cart'))

@app.route('/remove_from_cart/<int:cart_item_id>', methods=['POST'])
@login_required
def remove_from_cart(cart_item_id):
    cart_item = CartItem.query.get_or_404(cart_item_id)
    if cart_item.user_id != current_user.id:
        flash('Unauthorized', 'error')
        return redirect(url_for('cart'))
    
    db.session.delete(cart_item)
    db.session.commit()
    flash('Item removed from cart', 'info')
    return redirect(url_for('cart'))

# Order routes
@app.route('/checkout', methods=['GET', 'POST'])
@login_required
def checkout():
    cart_items = CartItem.query.filter_by(user_id=current_user.id).all()
    if not cart_items:
        flash('Your cart is empty', 'error')
        return redirect(url_for('cart'))
    
    form = OrderForm()
    if form.validate_on_submit():
        total = sum(item.menu_item.price * item.quantity for item in cart_items)
        order = Order(
            user_id=current_user.id,
            total_amount=total,
            delivery_address=form.delivery_address.data,
            phone=form.phone.data,
            status='pending'
        )
        db.session.add(order)
        db.session.flush()
        
        for cart_item in cart_items:
            order_item = OrderItem(
                order_id=order.id,
                menu_item_id=cart_item.menu_item_id,
                quantity=cart_item.quantity,
                price=cart_item.menu_item.price
            )
            db.session.add(order_item)
            db.session.delete(cart_item)
        
        db.session.commit()
        flash('Order placed successfully!', 'success')
        return redirect(url_for('order_history'))
    
    total = sum(item.menu_item.price * item.quantity for item in cart_items)
    return render_template('checkout.html', cart_items=cart_items, total=total, form=form)

@app.route('/orders')
@login_required
def order_history():
    orders = Order.query.filter_by(user_id=current_user.id).order_by(Order.created_at.desc()).all()
    # Calculate total items for each order
    for order in orders:
        order.total_items = sum(item.quantity for item in order.order_items)
    return render_template('orders.html', orders=orders)

@app.route('/order/<int:order_id>')
@login_required
def order_detail(order_id):
    order = Order.query.get_or_404(order_id)
    if order.user_id != current_user.id and not current_user.is_admin:
        flash('Unauthorized', 'error')
        return redirect(url_for('index'))
    return render_template('order_detail.html', order=order)

# Admin routes
@app.route('/admin')
@login_required
def admin_dashboard():
    if not current_user.is_admin:
        flash('Access denied', 'error')
        return redirect(url_for('index'))
    
    restaurants = Restaurant.query.all()
    orders = Order.query.order_by(Order.created_at.desc()).limit(10).all()
    return render_template('admin/dashboard.html', restaurants=restaurants, orders=orders)

@app.route('/admin/restaurants')
@login_required
def admin_restaurants():
    if not current_user.is_admin:
        flash('Access denied', 'error')
        return redirect(url_for('index'))
    
    restaurants = Restaurant.query.all()
    return render_template('admin/restaurants.html', restaurants=restaurants)

@app.route('/admin/restaurant/add', methods=['GET', 'POST'])
@login_required
def admin_add_restaurant():
    if not current_user.is_admin:
        flash('Access denied', 'error')
        return redirect(url_for('index'))
    
    form = RestaurantForm()
    if form.validate_on_submit():
        restaurant = Restaurant(
            name=form.name.data,
            description=form.description.data,
            address=form.address.data,
            phone=form.phone.data,
            image_url=form.image_url.data or 'https://via.placeholder.com/400x300?text=Restaurant'
        )
        db.session.add(restaurant)
        db.session.commit()
        flash('Restaurant added successfully!', 'success')
        return redirect(url_for('admin_restaurants'))
    return render_template('admin/add_restaurant.html', form=form)

@app.route('/admin/restaurant/<int:restaurant_id>/menu')
@login_required
def admin_restaurant_menu(restaurant_id):
    if not current_user.is_admin:
        flash('Access denied', 'error')
        return redirect(url_for('index'))
    
    restaurant = Restaurant.query.get_or_404(restaurant_id)
    menu_items = MenuItem.query.filter_by(restaurant_id=restaurant_id).all()
    return render_template('admin/menu.html', restaurant=restaurant, menu_items=menu_items)

@app.route('/admin/menu/add', methods=['GET', 'POST'])
@login_required
def admin_add_menu_item():
    if not current_user.is_admin:
        flash('Access denied', 'error')
        return redirect(url_for('index'))
    
    form = MenuItemForm()
    form.restaurant_id.choices = [(r.id, r.name) for r in Restaurant.query.all()]
    
    if form.validate_on_submit():
        menu_item = MenuItem(
            name=form.name.data,
            description=form.description.data,
            price=form.price.data,
            category=form.category.data,
            image_url=form.image_url.data or 'https://via.placeholder.com/300x200?text=Food',
            restaurant_id=form.restaurant_id.data
        )
        db.session.add(menu_item)
        db.session.commit()
        flash('Menu item added successfully!', 'success')
        return redirect(url_for('admin_restaurant_menu', restaurant_id=form.restaurant_id.data))
    return render_template('admin/add_menu_item.html', form=form)

@app.route('/admin/orders')
@login_required
def admin_orders():
    if not current_user.is_admin:
        flash('Access denied', 'error')
        return redirect(url_for('index'))
    
    orders = Order.query.order_by(Order.created_at.desc()).all()
    return render_template('admin/orders.html', orders=orders)

@app.route('/admin/order/<int:order_id>/update_status', methods=['POST'])
@login_required
def admin_update_order_status(order_id):
    if not current_user.is_admin:
        flash('Access denied', 'error')
        return redirect(url_for('index'))
    
    order = Order.query.get_or_404(order_id)
    new_status = request.form.get('status')
    if new_status in ['pending', 'confirmed', 'preparing', 'out_for_delivery', 'delivered', 'cancelled']:
        order.status = new_status
        order.updated_at = datetime.utcnow()
        db.session.commit()
        flash('Order status updated!', 'success')
    return redirect(url_for('admin_orders'))

if __name__ == '__main__':
    # Use environment variable for host/port or defaults
    host = os.environ.get('FLASK_HOST', '0.0.0.0')
    port = int(os.environ.get('FLASK_PORT', 5000))
    debug = app.config.get('FLASK_DEBUG', False)
    app.run(host=host, port=port, debug=debug)

