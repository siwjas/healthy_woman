# Domain Model - Pregnancy and Women's Health Application

## Models Overview

### User
- Responsibilities: Store user information and authentication details
- Relationships:
  - Has many `pregnancy_calculators` (dependent: :destroy)
  - Has many `menstrual_cycle_calculators` (dependent: :destroy)
  - Has many `bmi_calculators` (dependent: :destroy)

### PregnancyCalculator
- Responsibilities: Calculate and store pregnancy-related information
- Relationships:
  - Belongs to `user`

### MenstrualCycleCalculator
- Responsibilities: Calculate and store menstrual cycle and fertility information
- Relationships:
  - Belongs to `user`

### BmiCalculator
- Responsibilities: Calculate and store BMI and weight-related information
- Relationships:
  - Belongs to `user`

## Detailed Model Specifications

### User
```ruby
# app/models/user.rb
class User < ApplicationRecord
  # Associations
  has_many :pregnancy_calculators, dependent: :destroy
  has_many :menstrual_cycle_calculators, dependent: :destroy
  has_many :bmi_calculators, dependent: :destroy
  
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable
         
  # Validations
  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  
  # Attributes:
  # - id (integer, primary key)
  # - email (string)
  # - encrypted_password (string)
  # - first_name (string)
  # - last_name (string)
  # - date_of_birth (date)
  # - phone_number (string)
  # - agreed_to_terms (boolean)
  # - created_at (datetime)
  # - updated_at (datetime)
  # + Devise default fields
end
```

### PregnancyCalculator
```ruby
# app/models/pregnancy_calculator.rb
class PregnancyCalculator < ApplicationRecord
  # Associations
  belongs_to :user
  
  # Validations
  validates :last_menstrual_period_date, presence: true
  
  # Callbacks
  before_save :calculate_due_date
  before_save :calculate_gestational_age
  
  # Methods
  def calculate_due_date
    self.due_date = last_menstrual_period_date + 280.days
  end
  
  def calculate_gestational_age
    today = Date.current
    days_difference = (today - last_menstrual_period_date).to_i
    self.weeks = days_difference / 7
    self.days = days_difference % 7
  end
  
  def current_trimester
    return 1 if weeks < 13
    return 2 if weeks < 27
    return 3
  end
  
  # Attributes:
  # - id (integer, primary key)
  # - user_id (integer, foreign key)
  # - last_menstrual_period_date (date)
  # - due_date (date)
  # - weeks (integer)
  # - days (integer)
  # - notes (text)
  # - created_at (datetime)
  # - updated_at (datetime)
end
```

### MenstrualCycleCalculator
```ruby
# app/models/menstrual_cycle_calculator.rb
class MenstrualCycleCalculator < ApplicationRecord
  # Associations
  belongs_to :user
  
  # Validations
  validates :last_period_date, presence: true
  validates :cycle_length, presence: true, numericality: { greater_than: 0 }
  
  # Callbacks
  before_save :calculate_fertility_window
  before_save :calculate_next_period
  
  # Methods
  def calculate_fertility_window
    ovulation_day = last_period_date + (cycle_length - 14).days
    self.fertility_window_start = ovulation_day - 5.days
    self.fertility_window_end = ovulation_day + 1.day
    self.ovulation_date = ovulation_day
  end
  
  def calculate_next_period
    self.next_period_date = last_period_date + cycle_length.days
  end
  
  # Attributes:
  # - id (integer, primary key)
  # - user_id (integer, foreign key)
  # - last_period_date (date)
  # - cycle_length (integer, default: 28)
  # - period_duration (integer, default: 5)
  # - fertility_window_start (date)
  # - fertility_window_end (date)
  # - ovulation_date (date)
  # - next_period_date (date)
  # - notes (text)
  # - symptoms (jsonb)
  # - created_at (datetime)
  # - updated_at (datetime)
end
```

### BmiCalculator
```ruby
# app/models/bmi_calculator.rb
class BmiCalculator < ApplicationRecord
  # Associations
  belongs_to :user
  
  # Validations
  validates :weight, presence: true, numericality: { greater_than: 0 }
  validates :height, presence: true, numericality: { greater_than: 0 }
  
  # Callbacks
  before_save :calculate_bmi
  
  # Methods
  def calculate_bmi
    # BMI = weight(kg) / height²(m)
    self.bmi = (weight / (height * height)).round(2)
  end
  
  def bmi_category
    case bmi
    when 0..18.40
      'Underweight'
    when 18.5..24.99
      'Normal weight'
    when 25.0..29.90
      'Overweight'
    when 30.0..34.99
      'Obesity Class I'
    when 35.0..39.99
      'Obesity Class II'
    else
      'Obesity Class III'
    end
  end
  
  def pregnancy_weight_category
    return nil unless user.pregnancy_calculators.exists?
    
    # Specific pregnancy BMI recommendations would go here
    # This is a simplified version
    if user.pregnancy_calculators.any?
      # Custom logic for pregnancy weight recommendations
    end
  end
  
  # Attributes:
  # - id (integer, primary key)
  # - user_id (integer, foreign key)
  # - weight (decimal) - in kilograms
  # - height (decimal) - in meters
  # - bmi (decimal)
  # - is_pregnant (boolean)
  # - pre_pregnancy_weight (decimal)
  # - weight_goal (decimal)
  # - notes (text)
  # - created_at (datetime)
  # - updated_at (datetime)
end
```

## Database Migrations

### Users Table
```ruby
class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string  :email, null: false
      t.string  :encrypted_password, null: false
      t.string  :first_name, null: false
      t.string  :last_name, null: false
      t.date    :date_of_birth
      t.decimal :height, null: false, precision: 5, scale: 2
      t.string  :phone_number
      t.boolean :agreed_to_terms, default: false
      
      # Devise fields
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email
      
      t.timestamps
    end
    
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true
  end
end
```

### Pregnancy Calculators Table
```ruby
class CreatePregnancyCalculators < ActiveRecord::Migration[8.0]
  def change
    create_table :pregnancy_calculators do |t|
      t.references :user, null: false, foreign_key: true
      t.date :last_menstrual_period_date, null: false
      t.date :due_date
      t.integer :weeks
      t.integer :days
      
      t.timestamps
    end
    
    add_index :pregnancy_calculators, [:user_id, :created_at]
  end
end
```

### Menstrual Cycle Calculators Table
```ruby
class CreateMenstrualCycleCalculators < ActiveRecord::Migration[8.0]
  def change
    create_table :menstrual_cycle_calculators do |t|
      t.references :user, null: false, foreign_key: true
      t.date :last_period_date, null: false
      t.integer :cycle_length, default: 28
      t.integer :period_duration, default: 5
      t.date :fertility_window_start
      t.date :fertility_window_end
      t.date :ovulation_date
      t.date :next_period_date
      
      t.timestamps
    end
    
    add_index :menstrual_cycle_calculators, [:user_id, :created_at]
  end
end
```

### BMI Calculators Table
```ruby
class CreateBmiCalculators < ActiveRecord::Migration[8.0]
  def change
    create_table :bmi_calculators do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :weight, precision: 5, scale: 2, null: false
      t.decimal :height, precision: 3, scale: 2, null: false
      t.decimal :bmi, precision: 4, scale: 2
      t.boolean :is_pregnant, default: false
      t.decimal :pre_pregnancy_weight, precision: 5, scale: 2
      t.decimal :weight_goal, precision: 5, scale: 2
      
      t.timestamps
    end
    
    add_index :bmi_calculators, [:user_id, :created_at]
  end
end
```
