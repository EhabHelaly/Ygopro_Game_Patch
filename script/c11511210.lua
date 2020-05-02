--Dragonilian Frenuss
function c11511210.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(c11511210.filter,nil))
	c:RegisterEffect(e1)

end
function c11511210.filter(c)
	return c:IsSetCard(0xffd) and not Duel.IsExistingMatchingCard(Card.IsAttribute, c:GetControler(), LOCATION_MZONE,0,1,nil,c:GetAttribute()) 
end
