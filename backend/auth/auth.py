from fastapi import Depends, HTTPException, status
from sqlalchemy.orm import Session
from database import get_db
from models.usuarios import Usuario
from utils.security import verify_password, create_access_token
from schemas.auth import LoginRequest, TokenResponse

def login_user(data: LoginRequest, db: Session):
    user = db.query(Usuario).filter(Usuario.username == data.username).first()
    
    if not user or not verify_password(data.password, user.password_hash):
        raise HTTPException(status_code=401, detail="Credenciales incorrectas")
    
    if user.estado != "activo":
        raise HTTPException(status_code=403, detail="Usuario inactivo o suspendido")
    
    # Puedes registrar log aquí

    token_data = {
        "sub": str(user.id),
        "username": user.username,
        "rol_id": user.rol_id,
    }

    access_token = create_access_token(token_data)
    return TokenResponse(access_token=access_token)
