--Dennis Terrell
--Assignment 3 cs145
-- This assignment is incomplete.  


with Ada.Text_IO;		
use Ada.Text_IO;
with Ada.Integer_Text_IO;	
use Ada.Integer_Text_IO;
with Ada.Command_Line;		
use Ada.Command_Line;
with Ada.Exceptions;		
use Ada.Exceptions;
with gen_queue;					

procedure assignment3 is


	Input_File : file_type;
	Type Transaction is (Stock, Order);
	subtype customer_id is integer range 0 .. 1000000;
	subtype isbn_type is string(1 .. 10);
	type dollars is delta 0.01 range 0.0 .. 9999.0;
	type Back_order is record
		isbn        : isbn_type;
		quantity    : natural;
		customer_number : integer;

	end record;


	package transactions_io is new enumeration_io(transaction);
	use transactions_io;


	package dollar_io is new Fixed_IO(dollars);
	use dollar_io;

	package order_queue is new gen_queue(back_order);
	use order_queue;
-----------------------------------------------------------------------------------------------------------
	Type book_list;  
	
	Type book_list is record
		isbn : isbn_type;
		price : dollars;
		stock : natural;
		order_queue : queue_type;


	end record;



	max_size : integer := 20;
	type inventory is array (1 .. max_size) of book_list; --inventory array of the record book_list
	book_inventory : inventory;
	stock_counter  : integer :=0;
	invalid_argument : exception;
	empty : character;

---------------------------------------------------------------------------------------------------------

Procedure open_book_list is

	begin

		If argument_count = 2 then
			open (Input_File, in_file, argument(1));

		else

			Raise invalid_argument with "Must have two arguments ";

		end if;


		while not end_of_file(Input_File) loop

			stock_counter := stock_counter + 1;

			get (Input_File, book_inventory(stock_counter).ISBN);
			get (Input_File, empty);
			get (Input_File, book_inventory(stock_count).price);
			get (Input_File, empty);
			get (Input_File, book_inventory(stock_count).stock);


		end loop;

		close(Input_File);

end open_book_list;


----------------------------------------------------------------------------------------------------------------

Function isbn_search(isbn : in isbn_type) return integer is

	begin
		
		for n in 1 .. stock_counter loop
			if isbn = book_inventory(n).isbn then
				return n;

			else
				return 0;

			end if;

		end loop;

	end isbn_search;

------------------------------------------------------------------------------------------------------------------

Procedure transactions is

	transaction_type : transaction;
	isbn : isbn_type;
	new_stock : integer;
	id : customer_id;
	isbn_index : integer;


	Procedure book_stock is
	
	current_stock : integer := 0;

	Begin

		get (input_file, empty);
		get (input_file, isbn);
		get (input_file, empty);
		get (input_file, new_stock);
		isbn_index := search(isbn);
		
		current_stock := book_inventory(isbn_index).stock;
		book_inventory(isbn_index).stock := book_inventory(isbn_index).stock + new_stock; --updating the stock of the book

		put("Book stock for ");
		put(book_inventory(isbn_index).isbn);
		put(" went from ");
		put(current_stock);	
		put(" to ");
		put(book_inventory(isbn_index).stock);
		new_line;
		

	end book_stock;




	Procedure orders is
	new_back_orders : back_order;
	begin

		get (input_file, empty);
		get (input_file, isbn);
		get (input_file, empty);
		get (input_file, new_stock);
		get (input_file, empty);
		get (input_file, id);
	

		isbn_index := search(isbn);

		if new_stock = 1 then  --needed for correct output based on amount of stock in the transaction
		
			put("Order has been filled for customer id ");
			put(id);
			put(" with ");
			put(get_stock);
			put(" copy of book ");
			put(book_inventory(isbn_index).isbn);
			new_line;

			else if new_stock > 1 then

				put("Order has been filled for customer ");
				put(id);
				put(" with ");
				put(get_stock);
				put(" copies of book ");
				put(book_inventory(isbn_index).isbn);
				new_line;
	
			end if;
		end if;

		if book_inventory(isbn_index).stock - new_stock < 0 then --does back order need to be placed?
		
			new_back_orders := back_order'(isbn, id, new_stock - book_inventory(isbn_index).stock);  -- figures out what backorders there are
			enqueue(book_inventory(isbn_index).order_queue, new_back_orders); --adding to queue
			book_inventory(isbn_index).stock := 0;

			if back_order.quanity = 1 then
				
				Put("Back order of ");
				Put(back_order.quantity);
				Put(" isbn ");
				Put(back_order.isbn);
				Put(" for customer ");
				Put(back_order.customer_number);
				new_line;

			else if back_order.quantity > 1 then
				Put("Back order of ");
				Put(back_order.quantity);
				Put(" isbn ");
				Put(back_order.isbn);
				Put(" for customer ");
				Put(back_order.customer_number);
				new_line;

			end if;

		end if;
				

		end if;
		
			
	end orders;




	Begin --transactions 

		open(input_file, in_file, argument(2));

		while not end_of_file(input_file) loop
			get(input_file, transaction_type);

			if transaction_type = stock then
				transaction_type := book_stock;

				else if transaction_type = order then
					transaction_type := book_order;

				end if;
			end if;
		end loop;



	

	end transactions;







Begin -- assignment 3


	book_list;
	transactions;
	output;


end assignment3;






			
