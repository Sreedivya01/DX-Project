public class SalesManager1 {
 public static void findHighestValueOrder() {
        // Step 1: Query all orders with related product data for today
        List<Order_Data__c> orders = [
            SELECT Name, Customer_ID__c, Date_Time__c, Qty__c, Discount__c, 
                   Product__c, Product_Data__r.Retail_Price__c
            FROM Order_Data__c
            WHERE Date_Time__c = TODAY
        ];

        Decimal highestOrderValue = 0; // Track the highest order value
        Order_Data__c highestOrder = null; // Track the highest value order

        // Step 2: Iterate through orders to find the one with the highest value
        for (Order_Data__c order : orders) {
            if (order.Qty__c != null && order.Product_Data__r != null && order.Product_Data__r.Retail_Price__c != null) {
                // Calculate order value: Qty x Retail Price x (1 - Discount%)
                Decimal orderValue = order.Qty__c * order.Product_Data__r.Retail_Price__c * (1 - (order.Discount__c / 100));
                
                // Update the highest order if this order value is greater
                if (orderValue > highestOrderValue) {
                    highestOrderValue = orderValue;
                    highestOrder = order;
                }
            }
        }

        // Step 3: Display the result
        if (highestOrder != null) {
            // Format the Date_Time__c field to "Month D, YY hh:mm"
            String formattedDateTime = '';
            if (highestOrder.Date_Time__c != null) {
                formattedDateTime = highestOrder.Date_Time__c.format('MMMM d, yyyy hh:mm a');
            }

            // Debug the highest order details
            System.debug('Customer Name: ' + highestOrder.Customer_ID__c);
            System.debug('Order Value: £' + highestOrderValue);
            System.debug('Date & Time: ' + formattedDateTime);
        } else {
            System.debug('No valid orders found for today.');
        }
 }
    // busieshrs
    public static void findBusiestHour() {
        Date today = Date.today();
        
        // Query orders placed today
        List<Order_data__c> orders = [
            SELECT Date_Time__c, Qty__c
            FROM Order_data__c
            WHERE Date_Time__c = TODAY
        ];
        
        Map<Integer, Decimal> hourlySales = new Map<Integer, Decimal>();
        
        for (Order_data__c order : orders) {
            Integer hour = order.Date_Time__c.hour();
            if (hourlySales.containsKey(hour)) {
                hourlySales.put(hour, hourlySales.get(hour) + order.Qty__c);
            } else {
                hourlySales.put(hour, order.Qty__c);
            }
        }
        
        // Find the hour with the most items sold
        Integer busiestHour = -1;
        Decimal maxQty = 0;
        
        for (Integer hour : hourlySales.keySet()) {
            if (hourlySales.get(hour) > maxQty) {
                maxQty = hourlySales.get(hour);
                busiestHour = hour;
            }
        }
        
        System.debug('Busiest Hour: ' + busiestHour + ' with ' + maxQty + ' items sold');
    }
}