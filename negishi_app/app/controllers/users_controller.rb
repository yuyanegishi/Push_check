class UsersController < ApplicationController

  def show
    if logged_in?
      @user = User.find(params[:id])
      @addresses = @user.addresses
    else
      redirect_to books_path, flash: {danger: "ログイン、またはユーザー登録を行なってください"}
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the NC_BOOKS!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def update
    if logged_in?
      @cartitems = current_user.cart_items

      # 在庫切れ商品のピックアップ
      @errorpoint_stock = []
      @cartitems.each do | cartitem |
        if cartitem.quantity > cartitem.book.stock
          @errorpoint_stock << cartitem.book_id
        end
      end

      if @errorpoint_stock.empty?
        @user = User.find(params[:id])
        @user.update_attributes(user_params)
        redirect_to new_order_path
      else
        # 在庫不足により、再度購入手続きへ
        @message_stock = ""
        @errorpoint_stock.each do | book_id |
          @insufficient_book = Book.find_by(id: book_id)
          @message_stock << "#{@insufficient_book.title} "
        end
        redirect_to cart_items_path, flash: {danger: "#{@message_stock}の在庫が不足しています。再度確認の上購入手続きを行なってください"}
      end
    else
      redirect_to books_path, flash: {danger: "ログイン、またはユーザー登録を行なってください"}
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :selected_address)
    end

end
