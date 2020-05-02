--Vortex Rampage
function c11511528.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,11511515,aux.FilterBoolFunction(c11511528.filterF),1,true)
	--multi attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(c11511528.val)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetCondition(c11511528.con)
	c:RegisterEffect(e2)

end
function c11511528.filterF(c)
	if not Card.IsFusionAttribute then Card.IsFusionAttribute = Card.IsAttribute end
	return c:IsFusionSetCard(0xffa) and c:IsFusionAttribute(ATTRIBUTE_DARK)
end
function c11511528.filter(c)
	return c:IsSetCard(0xffa) and c:IsFaceup()
end
function c11511528.val(e)
	return Duel.GetMatchingGroup(c11511528.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil):GetClassCount(Card.GetRace)-1
end
function c11511528.con(e)
	return Duel.GetMatchingGroup(c11511528.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil):GetClassCount(Card.GetRace)==0
end
