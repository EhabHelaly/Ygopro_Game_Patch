--Vortex Revocation
function c11511540.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c11511540.condition)
	e1:SetTarget(c11511540.target)
	e1:SetOperation(c11511540.activate)
	c:RegisterEffect(e1)
end
function c11511540.filterR(c,race)
	return c:IsFaceup() and bit.band(c:GetRace(),race)~=0
end
function c11511540.filterC(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xffa)
	and not Duel.IsExistingMatchingCard(c11511540.filterR,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,c,c:GetRace()) 
end
function c11511540.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c11511540.filterC,tp,LOCATION_MZONE,0,1,nil,tp) then return false end
	return Duel.IsChainNegatable(ev) and  ep~=tp
end
function c11511540.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c11511540.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end