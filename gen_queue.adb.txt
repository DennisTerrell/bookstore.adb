with Ada.Unchecked_deallocation;

package body gen_queue is

	-- the clean-up procedure
	procedure kill is new Ada.Unchecked_Deallocation(node_type, node_link);

	-- procedure enqueue
	-- purpose:	add an item to the tail of the queue
	procedure enqueue(queue : in out queue_type; item : in element_type) is
	begin
		-- change the tail of the queue
		if queue.tail = null then
			queue.tail := new node_type'(item, null);
			queue.head := queue.tail;
		else
			queue.tail.next := new node_type'(item, null);
			queue.tail := queue.tail.next;
		end if;
		
	end enqueue;
	
	-- procedure dequeue
	-- purpose:	remove the item from the front of the queue
	-- exception:	raises queue_underflow on attempt to dequeue from an empty queue 
	procedure dequeue(queue : in out queue_type; item : out element_type) is
		node : node_link := queue.head;
	begin
		-- check for empty queue
		if queue.head = null then
			raise queue_underflow;
		end if;
	
		-- get the data item from the head of the queue	
		item := queue.head.data;
		
		-- move the head to whatever is next in the queue
		queue.head := queue.head.next;
		
		-- if the queue is now empty, set tail to null as well
		if queue.head = null then
			queue.tail := null;
		end if;
		
		-- now clean up
		kill(node);
	end dequeue;
	
	-- function isEmpty
	-- purpose:	determine whether the queue is empty
	function isEmpty(queue : in queue_type) return boolean is
	begin
		return queue.head = null;
	end isEmpty;
	
end gen_queue;
	
