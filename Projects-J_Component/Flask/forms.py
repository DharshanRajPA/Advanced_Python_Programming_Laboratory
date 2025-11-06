from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, TextAreaField, FloatField, IntegerField, SelectField, BooleanField
from wtforms.validators import DataRequired, Email, EqualTo, Length, NumberRange

class LoginForm(FlaskForm):
    username = StringField('Username', validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired()])

class RegisterForm(FlaskForm):
    username = StringField('Username', validators=[DataRequired(), Length(min=4, max=20)])
    email = StringField('Email', validators=[DataRequired(), Email()])
    password = PasswordField('Password', validators=[DataRequired(), Length(min=6)])
    confirm_password = PasswordField('Confirm Password', validators=[DataRequired(), EqualTo('password')])

class RestaurantForm(FlaskForm):
    name = StringField('Restaurant Name', validators=[DataRequired()])
    description = TextAreaField('Description')
    address = StringField('Address')
    phone = StringField('Phone')
    image_url = StringField('Image URL')

class MenuItemForm(FlaskForm):
    name = StringField('Item Name', validators=[DataRequired()])
    description = TextAreaField('Description')
    price = FloatField('Price', validators=[DataRequired(), NumberRange(min=0)])
    category = StringField('Category')
    image_url = StringField('Image URL')
    restaurant_id = SelectField('Restaurant', coerce=int, validators=[DataRequired()])

class OrderForm(FlaskForm):
    delivery_address = StringField('Delivery Address', validators=[DataRequired()])
    phone = StringField('Phone Number', validators=[DataRequired()])

