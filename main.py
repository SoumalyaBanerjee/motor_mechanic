from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import psycopg2
from typing import List
from typing import Optional

app = FastAPI()

from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # allow all origins for testing
    allow_methods=["*"],  # allow GET, POST, OPTIONS, etc.
    allow_headers=["*"],  # allow any headers
)


# --- PostgreSQL connection ---
def get_db_connection():
    conn = psycopg2.connect(
        host="88vsz4.h.filess.io",
        port=61006,  # your custom port
        database="UrbanMoto_curveocean",
        user="UrbanMoto_curveocean",
        password="209a1cf2acd79ff8693b600f9cae5921baef747d"
    )
    return conn

# --- Pydantic models ---
class BookingRequest(BaseModel):
    customer_id: int
    mechanic_id: int
    bike_brand: str
    bike_model: str
    bike_reg_no: str = None
    service_category: str
    service_type: str
    preferred_date: str
    preferred_time: str
    service_notes: str = None
    estimated_cost: float
    payment_method: str


class Mechanic(BaseModel):
    mechanic_id: int
    mechanic_name: str
    mechanic_category: Optional[str] = None
    workshop_name: str
    verified_status: Optional[str] = None


# --- Routes ---

@app.get("/")
def root():
    return {"message": "FastAPI backend is running!"}


@app.post("/create_booking")
def create_booking(booking: BookingRequest):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("""
        INSERT INTO urban_services.bookings (
            customer_id, mechanic_id, bike_brand, bike_model, bike_reg_no,
            service_category, service_type, preferred_date, preferred_time,
            service_notes, estimated_cost, payment_method
        ) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
        RETURNING order_id;
    """, (
        booking.customer_id, booking.mechanic_id, booking.bike_brand,
        booking.bike_model, booking.bike_reg_no, booking.service_category,
        booking.service_type, booking.preferred_date, booking.preferred_time,
        booking.service_notes, booking.estimated_cost, booking.payment_method
    ))
    order_id = cur.fetchone()[0]
    conn.commit()
    cur.close()
    conn.close()
    return {"order_id": order_id, "message": "Booking created successfully"}

@app.get("/mechanics", response_model=List[Mechanic])
def get_mechanics():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("""
        SELECT mechanic_id, mechanic_name, mechanic_category, workshop_name, verified_status
        FROM urban_services.mechanic_details
        -- WHERE verified_status='YES';
    """)
    rows = cur.fetchall()
    cur.close()
    conn.close()

    mechanics = []
    for row in rows:
        mechanics.append({
            "mechanic_id": row[0],
            "mechanic_name": row[1],
            "mechanic_category": row[2],
            "workshop_name": row[3],
            "verified_status": row[4]
        })
    return mechanics
