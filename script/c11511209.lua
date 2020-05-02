--Dragonilian Balerion
function c11511209.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c11511209.negcon)
	e1:SetTarget(c11511209.negtg)
	e1:SetOperation(c11511209.negop)
	c:RegisterEffect(e1)
end

function c11511209.filterE(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsControler(1-tp) and c:IsFaceup() 
end
function c11511209.filterM(c)
	return c:IsSetCard(0xffd) and c:IsFaceup() 
end
function c11511209.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainDisablable(ev) and  ep~=tp 
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c11511209.filterM,tp,LOCATION_MZONE,0,1,nil)
	and not Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_MZONE,0,1,nil,e:GetHandler():GetAttribute())
end
function c11511209.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c11511209.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	end
end
