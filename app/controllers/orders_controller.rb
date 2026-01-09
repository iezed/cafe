class OrdersController < ApplicationController
  load_and_authorize_resource
  before_action :set_order, only: [:show]

  # GET /orders
  # GET /orders.json
  def index
    params[:per_page] = 10 unless params[:per_page].present?

    condition = { branch_id: session[:branch_id], enable: true }
    condition_sql = '1=1'
    sql_params = []

    if params[:start_date].present?
      condition_sql += " AND transaction_date>=?"
      sql_params << params[:start_date].to_date
    end

    if params[:end_date].present?
      condition_sql += " AND transaction_date<=?"
      sql_params << params[:end_date].to_date
    end

    @order_count = Order.where(condition).where(condition_sql, *sql_params).count
    @orders = Order.where(condition).where(condition_sql, *sql_params).page(params[:page]).per(params[:per_page]).order('id desc')
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    session[:locale] = I18n.default_locale
  end

  # GET /orders/new
  def new
    params[:per_page] = 10 unless params[:per_page].present?

    @order = Order.new
    @order.order_products.build

    condition = { branch_id: current_user.branch_id, enable: true }

    if @current_branch_setting.use_product_category
      @product_categories = ProductCategory.where(condition)

      if params[:product_category_id]
        @product_category = ProductCategory.find(params[:product_category_id])
      else
        unless @product_categories.empty?
          @product_category = @product_categories.first
        end
      end
    end

    @user_counts = 0

    like = false

    if params[:search_field].present? and params[:search_word].present?
      case params[:search_field]
      when 'name'
        condition_sql = 'name like ?'
        like = true
      when 'phone'
        condition_sql = 'phone like ?'
        like = true
      when 'unique_number'
        condition_sql = 'user_unique_numbers.unique_number like ?'
        like = true
      end
    end

    if like
      @user_count = User.includes(:user_anon).includes(:user_unique_number).where(condition).where(condition_sql, '%' + params[:search_word].strip + '%').count
      @users = User.select('users.*,user_anons.id as anon_id').includes(:user_anon).includes(:user_unique_number).where(condition).where(condition_sql, '%' + params[:search_word].strip + '%').page(params[:page]).per(params[:per_page]).order('id desc')
    else
      @user_count = User.includes(:user_anon).includes(:user_unique_number).where(condition).count
      @users = User.select('users.*,user_anons.id as anon_id').includes(:user_anon).includes(:user_unique_number).where(condition).page(params[:page]).per(params[:per_page]).order('id desc')
    end

    if @user_counts == 1
      @user = @users[0]
    end

    if @current_branch_setting.use_product_category
      if @product_category.present?
        condition[:product_category_id] = @product_category.id
      else
        condition[:product_category_id] = nil
      end
    end

    @products = Product.where(condition).order('id desc').page(params[:page]).per(params[:per_page])

    @payment_count = Payment.joins(:branch_setting_payments).where({ :branch_setting_payments => { branch_setting_id: @current_branch_setting, enable: true }, enable: true }).count
    @payments = Payment.joins(:branch_setting_payments).where({ :branch_setting_payments => { branch_setting_id: @current_branch_setting, enable: true }, enable: true })
  end

  # POST /orders
  # POST /orders.json
  def create
    begin

      @order = Order.new(order_params)
      result=@order.save!

      OrderUser.create!(:order_id => @order.id, :user_id => current_user.id)

      ca = calculate_account(@order.order_products)
      OrderPayment.create!(:order_id => @order.id, :payment_id => params[:payment_method])
      puts "calculate_account result: #{ca.inspect}"
      @order.update(price: ca[:total_price], payment: ca[:total_price])

      ActionCable.server.broadcast(
        "admin_orders",
        {
          event: "order_created",
          order_id: @order.id,
          payment: @order.payment,
          payment_method: params[:payment_method],
          transaction_date: I18n.l(
            @order.transaction_date.to_date,
            format: :long
          ),
          created_at: @order.created_at.strftime("%H:%M"),
          user_name: current_user.name,

          payments: @order.payments.map(&:title),
          products: @order.order_products.map { |op| op.product.title }
        }
      )

      respond_to do |format|
        if result
          format.html { redirect_to order_path(@order, locale: params[:locale].presence) }
          format.json { render :show, status: :created, location: @order }
        else
          format.html { render :new }
          format.json { render json: @order.errors, status: :unprocessable_content }
        end
      end

    rescue ActiveRecord::RecordInvalid => exception
      flash[:alert] = exception.message
      redirect_to new_order_path
    end
  end


  private

  def calculate_account(s)
    a = { total_price: 0 }
    if s.empty?
      return a
    end

    s.each do |ss|
      product = Product.find(ss.product.id)
      pp = product.price * ss.quantity

      a[:total_price] += pp
    end

    return a
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def order_params
    unless params[:order][:user_id]
      params[:order][:user_id] = current_user.id
    end

    params.require(:order).permit(:user_id, :transaction_date, :price, :discount, :payment, order_products_attributes: [:product_id, :price, :quantity]).merge(branch_id: current_user.branch_id)
  end
end
