--Elegantea Barrier
function c11511053.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c11511053.condition)
	e1:SetTarget(c11511053.target)
	e1:SetOperation(c11511053.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c11511053.con)
	e2:SetTarget(c11511053.settg)
	e2:SetOperation(c11511053.setop)
	c:RegisterEffect(e2)
end
function c11511053.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff)
end
function c11511053.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c11511053.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
		return Duel.IsChainNegatable(ev) and  ep~=tp and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c11511053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c11511053.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c11511053.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xff) and c:IsType(TYPE_XYZ)
end
function c11511053.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp and (e:GetHandler():GetTurnID()~=Duel.GetTurnCount() or e:GetHandler():IsReason(REASON_RETURN))
        and Duel.IsExistingMatchingCard(c11511053.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
function c11511053.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c11511053.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end