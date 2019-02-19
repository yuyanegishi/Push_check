class CartItemsController < ApplicationController

  def create 
    if logged_in?
      @cartitem = CartItem.new(cartitem_params)
      @book = @cartitem.book

      if cartitem = CartItem.find_by(user_id: current_user.id, book_id: @cartitem.book_id)
        if cartitem.quantity+@cartitem.quantity <= 10

          if cartitem.quantity+@cartitem.quantity > cartitem.book.stock
            redirect_to @book, flash: {danger: "在庫が不足しています。確認の上再度数量を選択してください"} 
          else
            cartitem.update(quantity: cartitem.quantity+@cartitem.quantity )
            redirect_to cart_items_path
          end

        else
          redirect_to @book, flash: {danger: "一つの商品を一度に購入できるのは10個までとなっています（上限から#{cartitem.quantity+@cartitem.quantity-10}個超過しています）"}
        end
      else

        if @cartitem.quantity > @cartitem.book.stock
          redirect_to @book, flash: {danger: "在庫が不足しています。確認の上再度数量を選択してください"}
        else
          @cartitem.save
          redirect_to cart_items_path
        end
      end
    else
      redirect_to books_path, flash: {danger: "ログイン、またはユーザー登録を行なってください"}
    end
  end

  def index
    if logged_in?
      @cartitems = current_user.cart_items
      @errorpoint = 0

      @cartitems.each do | cartitem |
        unless cartitem.planned_price == cartitem.book.price
          @errorpoint += 1
        end
        cartitem.update(planned_price: cartitem.book.price)
      end

      @sum_quantity = 0
      @sum_price = 0
      @cartitems.each do | cartitem |
        @sum_quantity += cartitem.quantity
        @sum_price += cartitem.quantity * cartitem.book.price
      end
    else
      redirect_to books_path, flash: {danger: "ログイン、またはユーザー登録を行なってください"}
    end
  end

  def destroy
    if logged_in?
      @cartitem = CartItem.find_by(id: params[:id])
      if @cartitem.nil?
        redirect_to cart_items_path, flash: {danger: "選択された商品は既に削除されています"}
      else
        @cartitem.destroy
        redirect_to cart_items_path, flash: {success: "削除が完了しました"}
      end
    else
      redirect_to books_path, flash: {danger: "ログイン、またはユーザー登録を行なってください"}
    end
  end

  def update
    if logged_in?
      @cartitem = CartItem.find_by(id: params[:id])
      if @cartitem.nil?
        redirect_to cart_items_path, flash: {danger: "選択された商品は既に削除されています"}
      else
        if params[:cart_item][:quantity].to_i > @cartitem.book.stock
          redirect_to cart_items_path, flash: {danger: "在庫が不足しています。確認の上再度数量を選択してください"}
        else    
          @cartitem.update(quantity: params[:cart_item][:quantity])
          redirect_to cart_items_path, flash: {success: "数量の変更が完了しました"}
        end
      end
    else
      redirect_to books_path, flash: {danger: "ログイン、またはユーザー登録を行なってください"}
    end
  end

  private

    def cartitem_params
      params.require(:cart_item).permit(:user_id, :book_id, :quantity, :planned_price)
    end

end
