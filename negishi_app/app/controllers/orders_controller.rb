class OrdersController < ApplicationController
  def new
    if logged_in?
      @order = Order.new
      @addresses = current_user.addresses
      if @addresses.empty?
        redirect_to registration_path, flash: {danger: "住所を登録の上購入手続きを行なってください"}
      else

        @address = Address.find_by(id: current_user.selected_address)
        if @address.nil?
          redirect_to addresses_path, flash: {danger: "住所を選択の上購入手続きを行なってください"}
        else

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
        end
      end
    else
      redirect_to books_path, flash: {danger: "ログイン、またはユーザー登録を行なってください"}
    end
  end

  def create
    if logged_in?
      @cartitems = current_user.cart_items

      if @cartitems.empty?
        redirect_to books_path, flash: {danger: '選択された商品は既に注文が確定しています'}
      else

        # 在庫切れ商品のピックアップ
        @errorpoint_stock = []
        @cartitems.each do | cartitem |
          if cartitem.quantity > cartitem.book.stock
            @errorpoint_stock << cartitem.book_id
          end
        end

        if @errorpoint_stock.empty?

          # 在庫切れ商品がない場合、価格の変動が無いか確認
          @errorpoint_price = 0
          @cartitems.each do | cartitem |
            unless cartitem.planned_price == cartitem.book.price
              @errorpoint += 1
            end
            cartitem.update(planned_price: cartitem.book.price)
          end

          if @errorpoint_price == 0

            # 購入確定
            @address = Address.find_by(id: current_user.selected_address)
            @order = Order.new(consignee: @address.consignee, first_postal_code: @address.first_postal_code, last_postal_code: @address.last_postal_code, first_address: @address.first_address, second_address: @address.second_address, phone: @address.phone, user_id: current_user.id)
            @order.save

            @cartitems.each do | cartitem |
              @book = Book.find_by(id: cartitem.book_id)
              @order_item = OrderItem.new(order_id: @order.id, book_id: cartitem.book_id, quantity: cartitem.quantity, purchase_price: @book.price)
              @order_item.save
              @book.update(stock: @book.stock-cartitem.quantity)
              cartitem.destroy
            end
            redirect_to order_path(@order_item)
          else

            # 価格の変動があり、再度購入手続きへ
            redirect_to new_order_path, flash: {danger: '確認していただいた時点と価格が変わっているので確認の上購入手続きを行ってください'}
          end

        else

          # 在庫不足により、再度購入手続きへ
          @message_stock = ""
          @errorpoint_stock.each do | book_id |
            @insufficient_book = Book.find_by(id: book_id)
            @message_stock << "#{@insufficient_book.title} "
          end
          redirect_to cart_items_path, flash: {danger: "#{@message_stock}の在庫が不足しています。再度確認の上購入手続きを行なってください"}
        end
      end
    else
      redirect_to books_path, flash: {danger: "ログイン、またはユーザー登録を行なってください"}
    end
  end

  def show
    unless logged_in?
      redirect_to books_path, flash: {danger: "ログイン、またはユーザー登録を行なってください"}
    end
  end

end
