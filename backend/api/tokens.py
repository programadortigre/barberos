from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from datetime import datetime
from typing import List, Optional

from database import get_db
from models.tokens import Token, TipoTokenEnum
from schemas.tokens import TokenCreate, TokenRead, TokenUpdateRevocado

router = APIRouter(prefix="/tokens", tags=["tokens"])

@router.post("/", response_model=TokenRead, status_code=status.HTTP_201_CREATED)
def crear_token(token_in: TokenCreate, db: Session = Depends(get_db)):
    # Verificar que el token no exista
    token_exist = db.query(Token).filter(Token.token == token_in.token).first()
    if token_exist:
        raise HTTPException(status_code=400, detail="Token ya existe")
    nuevo_token = Token(**token_in.dict())
    db.add(nuevo_token)
    db.commit()
    db.refresh(nuevo_token)
    return nuevo_token

@router.get("/", response_model=List[TokenRead])
def listar_tokens(skip: int = 0, limit: int = 100, usuario_id: Optional[int] = None, db: Session = Depends(get_db)):
    query = db.query(Token)
    if usuario_id is not None:
        query = query.filter(Token.usuario_id == usuario_id)
    tokens = query.offset(skip).limit(limit).all()
    return tokens

@router.get("/{token}", response_model=TokenRead)
def obtener_token(token: str, db: Session = Depends(get_db)):
    token_obj = db.query(Token).filter(Token.token == token).first()
    if not token_obj:
        raise HTTPException(status_code=404, detail="Token no encontrado")
    return token_obj

@router.patch("/{token}", response_model=TokenRead)
def actualizar_revocacion_token(token: str, data: TokenUpdateRevocado, db: Session = Depends(get_db)):
    token_obj = db.query(Token).filter(Token.token == token).first()
    if not token_obj:
        raise HTTPException(status_code=404, detail="Token no encontrado")
    if data.revocado:
        token_obj.revocado = True
        token_obj.revocado_at = data.revocado_at or datetime.utcnow()
    else:
        token_obj.revocado = False
        token_obj.revocado_at = None
    db.commit()
    db.refresh(token_obj)
    return token_obj

@router.delete("/{token}", status_code=status.HTTP_204_NO_CONTENT)
def eliminar_token(token: str, db: Session = Depends(get_db)):
    token_obj = db.query(Token).filter(Token.token == token).first()
    if not token_obj:
        raise HTTPException(status_code=404, detail="Token no encontrado")
    db.delete(token_obj)
    db.commit()
    return
