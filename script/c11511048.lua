-- Art of Anchient Witchery
function c11511048.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c11511048.cost)
	e1:SetTarget(c11511048.target)
	e1:SetOperation(c11511048.activate)
	c:RegisterEffect(e1)
	--destroy face down
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c11511048.descost)
	e2:SetCondition(c11511048.xyzcon)
	e2:SetTarget(c11511048.destarget)
	e2:SetOperation(c11511048.desactivate)
	c:RegisterEffect(e2)

end
function c11511048.cfilter(c)
	return c:IsSetCard(0xfff) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c11511048.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11511048.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c11511048.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c11511048.filter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c11511048.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c11511048.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c11511048.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c11511048.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetChainLimit(c11511048.limit(g:GetFirst()))
end
function c11511048.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c11511048.limit(c)
	return	function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c11511048.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11511048.mfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xfff)
end
function c11511048.xyzfilter1(c,g,ct)
	return g:IsExists(c11511048.xyzfilter2,ct,c,c:GetRank(),c:GetCode())
end
function c11511048.xyzfilter2(c,rk,cd)
	return c:GetRank()==rk and  c:GetCode()~=cd
end
function c11511048.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=e:GetHandler():GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=math.max(1,-ft)
	local mg=Duel.GetMatchingGroup(c11511048.mfilter,tp,LOCATION_MZONE,0,nil)
	return mg:IsExists(c11511048.xyzfilter1,1,nil,mg,ct)
end
function c11511048.desfilter(c)
	return c:IsFacedown() and c:IsDestructable()
end
function c11511048.destarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11511048.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c11511048.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c11511048.desactivate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11511048.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
