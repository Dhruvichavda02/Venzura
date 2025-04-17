<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Better session validation
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect("../Login.jsp");
        return;
    }

    // Get all required attributes with null checks
    Object bookingIdObj = session.getAttribute("bookingId");
    Object totalAmountObj = session.getAttribute("totalAmount");
    String startDateStr = (String) session.getAttribute("startDate");
    String endDateStr = (String) session.getAttribute("endDate");

    if (bookingIdObj == null || totalAmountObj == null || startDateStr == null || endDateStr == null) {
        response.sendRedirect("Booking.jsp?error=missing_data");
        return;
    }

    int bookingId;
    double totalAmount;
    try {
        bookingId = Integer.parseInt(bookingIdObj.toString());
        totalAmount = Double.parseDouble(totalAmountObj.toString());
    } catch (NumberFormatException e) {
        response.sendRedirect("Booking.jsp?error=invalid_data");
        return;
    }

    int amountInPaise = (int) (totalAmount * 100);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Payment Page</title>
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <style>
        .payment-container {
            max-width: 600px;
            margin: 20px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        #payBtn {
            background-color: #3399cc;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        #payBtn:hover {
            background-color: #2a7aaf;
        }
    </style>
</head>
<body>
    <div class="payment-container">
        <h2>Confirm Payment</h2>
        <p><strong>Booking ID:</strong> <%= bookingId %></p>
        <p><strong>Total Amount:</strong> ₹<%= String.format("%.2f", totalAmount) %></p>
        <p><strong>Start Date:</strong> <%= startDateStr %></p>
        <p><strong>End Date:</strong> <%= endDateStr %></p>

        <button id="payBtn">Pay Now</button>
        <div id="error-message" style="color: red; margin-top: 10px;"></div>
    </div>

    <script>
        const options = {
            "key": "rzp_test_AQWJhTr5CGLwF2",
            "amount": "<%= amountInPaise %>", 
            "currency": "INR",
            "name": "Venzura Booking",
            "description": "Venue Payment",
            "handler": function (response) {
                console.log("Razorpay response:", response);
                
                fetch('<%= request.getContextPath() %>/PaymentSuccessServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `bookingId=<%= bookingId %>&paymentId=${response.razorpay_payment_id}&amount=<%= amountInPaise %>`
                })
                .then(res => {
                    if (!res.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return res.json();
                })
                .then(data => {
                    console.log("Server response:", data);
                    if(data.success) {
                        window.location.href = "ThankYou.jsp?bookingId=<%= bookingId %>&payment_id=" + 
                                              response.razorpay_payment_id;
                    } else {
                        document.getElementById('error-message').textContent = 
                            "Payment verification failed: " + (data.message || 'Unknown error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('error-message').textContent = 
                        "Error processing payment: " + error.message;
                });
            },
            "prefill": {
                "email": "<%= session.getAttribute("email") != null ? session.getAttribute("email") : "" %>",
                "contact": "<%= session.getAttribute("phone") != null ? session.getAttribute("phone") : "" %>"
            },
            "theme": {
                "color": "#3399cc"
            }
        };
        
        const rzp = new Razorpay(options);
        
        rzp.on('payment.failed', function(response){
            console.error('Payment failed:', response.error);
            document.getElementById('error-message').textContent = 
                "Payment failed: " + (response.error.description || 'Unknown error');
        });

        document.getElementById("payBtn").onclick = function (e) {
            document.getElementById('error-message').textContent = '';
            rzp.open();
            e.preventDefault();
        };
    </script>
</body>
</html>