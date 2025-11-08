from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from mangum import Mangum
import random

app = FastAPI(title="E-Commerce API", version="1.0")

# ✅ Add CORS middleware before any routes
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],   
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- API endpoint: E-Commerce ---
@app.post("/discount_vendor_info")
async def add_to_cart(request: Request):
    try:
        data = await request.json()
        print("🔍 Received data:", data)

        # Expecting { "product_id": 1, "name": "Product Name", "price": 499 }
        product_id = data.get("product_id")
        name = data.get("name")
        price = data.get("price")

        if not all([product_id, name, price]):
            raise HTTPException(status_code=400, detail="Missing product details")

        # Simulate discount and vendor
        discount = random.choice([0, 5, 10, 15, 20])
        vendor = random.choice(["TechWorld", "ShopEase", "ElectroMart", "MegaDeals"])

        if discount > 0:
            message = f"{discount}% discount available from {vendor} for {name}."
        else:
            message = f"No current discounts for {name}."

        return {"message": message}

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Processing failed: {str(e)}")


# --- AWS Lambda handler ---
lambda_handler = Mangum(app)