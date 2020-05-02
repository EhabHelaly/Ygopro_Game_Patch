--Vortex Brawn
function c11511533.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,11511504,aux.FilterBoolFunction(c11511533.filterF),1,true)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCountLimit(3)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c11511533.negcon)
	e1:SetTarget(c11511533.negtg)
	e1:SetOperation(c11511533.negop)
	c:RegisterEffect(e1)
end
function c11511533.filterF(c)
	return c:IsFusionSetCard(0xffa) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c11511533.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsType(TYPE_MONSTER) and rp~=tp and Duel.IsChainNegatable(ev)
end
function c11511533.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c11511533.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.NegateActivation(ev) 
	end
end
