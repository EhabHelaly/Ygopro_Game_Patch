--SW Race
function c11511451.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c11511451.condition)
	e1:SetTarget(c11511451.target)
	e1:SetOperation(c11511451.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c11511451.cost2)
	e2:SetCondition(c11511451.con2)
	e2:SetTarget(c11511451.tg2)
	e2:SetOperation(c11511451.op2)
	c:RegisterEffect(e2)
end
function c11511451.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated() 
end
function c11511451.tcfilter(tc,ec)
	return tc:IsFaceup() and ec:CheckEquipTarget(tc) and tc:IsSetCard(0xffb)
end
function c11511451.ecfilter(c,tp)
	return c:IsType(TYPE_EQUIP) and Duel.IsExistingTarget(c11511451.tcfilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function c11511451.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=e:GetHandler():IsLocation(LOCATION_SZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c11511451.ecfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,tp)
			and ( Duel.GetLocationCount(tp,LOCATION_SZONE)>1 or (loc and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 ) )
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,c11511451.ecfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp)
	local ec=g:GetFirst()
	e:SetLabelObject(ec)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c11511451.tcfilter,tp,LOCATION_MZONE,0,1,1,ec:GetEquipTarget(),ec)
	
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,ec,1,0,0)
end
function c11511451.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local ec=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Equip(tp,ec,tc)
	end
end
function c11511451.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11511451.filter(c)
	return c:IsSetCard(0xffb) and c:IsFaceup()
end
function c11511451.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11511451.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c11511451.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler()==1-tp and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_SZONE,1,nil) end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local max=Duel.GetMatchingGroupCount(c11511451.filter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_SZONE,1,max,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c11511451.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
