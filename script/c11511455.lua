--SW Peace Treaty
function c11511455.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCost(c11511455.cost)
	e1:SetCondition(c11511455.condition)
	e1:SetTarget(c11511455.target)
	e1:SetOperation(c11511455.activate)
	c:RegisterEffect(e1)
end
function c11511455.filter(c)
	return c:IsDiscardable() and c:IsSetCard(0xffb) and c:IsType(TYPE_MONSTER)
end
function c11511455.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11511455.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c11511455.filter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c11511455.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:GetHandler():IsType(TYPE_MONSTER))
end
function c11511455.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c11511455.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
