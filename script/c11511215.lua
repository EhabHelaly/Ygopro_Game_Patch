--Dragonilian Atherous
function c11511215.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c11511215.spcon)
	c:RegisterEffect(e1)
end
function c11511215.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xffd)
end
function c11511215.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 
	and Duel.IsExistingMatchingCard(c11511215.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
	and not Duel.IsExistingMatchingCard(Card.IsAttribute,c:GetControler(),LOCATION_MZONE,0,1,nil,c:GetAttribute())
end
