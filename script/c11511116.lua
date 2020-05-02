--The Magic within the Land
function c11511116.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11511116.target)
	e1:SetOperation(c11511116.activate)
	c:RegisterEffect(e1)
end
function c11511116.filter(c)
	return c:IsSetCard(0xffe) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c11511116.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c11511116.filter,tp,LOCATION_EXTRA,0,1,nil)
	 and (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c11511116.filter,tp,LOCATION_EXTRA,0,1,1,nil)
end
function c11511116.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if not tc:IsRelateToEffect(e) then return end
    if Duel.CheckLocation(tp,LOCATION_SZONE,6) then
    Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,6)
    else
    Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,7)
    end
end
