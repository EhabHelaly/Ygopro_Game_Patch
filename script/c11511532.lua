--Vortex Prudence
function c11511532.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,11511503,aux.FilterBoolFunction(c11511532.filterF),1,true)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c11511532.distg)
	c:RegisterEffect(e1)
	--disable effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c11511532.disop)
	c:RegisterEffect(e2)
end
function c11511532.filterF(c)
	return c:IsFusionSetCard(0xffa) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c11511532.filter(c,race)
	return c:IsSetCard(0xffa) and c:IsFaceup() and c:IsRace(race)
end
function c11511532.distg(e,c)
	return Duel.IsExistingMatchingCard(c11511532.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,c:GetRace()) 
end
function c11511532.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsLocation(LOCATION_MZONE) and rc:IsControler(1-tp) 
		and Duel.IsExistingMatchingCard(c11511532.filter,tp,LOCATION_MZONE,0,1,nil,rc:GetRace()) then
		Duel.NegateEffect(ev)
	end
end
