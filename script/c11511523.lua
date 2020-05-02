--Vortex Judgement
function c11511523.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,11511511,aux.FilterBoolFunction(c11511523.filterF),1,true)
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetTarget(c11511523.target)
	c:RegisterEffect(e1)

end
function c11511523.filterF(c)
	if not Card.IsFusionAttribute then Card.IsFusionAttribute = Card.IsAttribute end
	return c:IsFusionSetCard(0xffa) and c:IsFusionAttribute(ATTRIBUTE_EARTH)
end
function c11511523.filter(c,race)
	return c:IsSetCard(0xffa) and c:IsFaceup() and c:IsRace(race)
end
function c11511523.target(e,c)
	return Duel.IsExistingMatchingCard(c11511523.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil,c:GetRace())
end