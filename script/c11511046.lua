--Art of Evoulotion
function c11511046.initial_effect(c)
	--lv change
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11511046.target)
	e1:SetOperation(c11511046.operation)
	c:RegisterEffect(e1)
	--lv change grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LVCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c11511046.con)
	e2:SetCost(c11511046.cost)
	e2:SetTarget(c11511046.target)
	e2:SetOperation(c11511046.operation)
	c:RegisterEffect(e2)
end
function c11511046.filter(c,tp)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsSetCard(0xfff) and c:IsControler(tp)
end
function c11511046.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c11511046.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11511046.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c11511046.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	local t={}
	local i=1
	local p=1
	local lv=tc:GetLevel()
	for i=1,12 do
		if lv~=i then t[p]=i p=p+1 end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11511046,0))
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c11511046.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c11511046.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and (e:GetHandler():GetTurnID()~=Duel.GetTurnCount() or e:GetHandler():IsReason(REASON_RETURN))
end
function c11511046.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
