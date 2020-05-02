--Dragonilian Ouza
function c11511235.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(c11511235.filterxyz),4,2,c11511235.filterxyzOV,aux.Stringid(11511235,0),2,c11511235.xyzop)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,11511235)
	e1:SetCost(c11511235.cost)
	e1:SetCondition(c11511235.con)
	e1:SetTarget(c11511235.target)
	e1:SetOperation(c11511235.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c11511235.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayCount()>0 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c11511235.filterSP(c,tp)
	return c:GetSummonPlayer()==tp and c:IsSetCard(0xffd) 
	and Duel.IsExistingMatchingCard(c11511235.filterD,tp,0,LOCATION_MZONE,1,nil,c:GetAttribute())
end
function c11511235.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11511235.filterSP,1,nil,tp)
end
function c11511235.filterD(c,att)
	return c:IsFaceup() and c:IsDestructable() and c:IsAttribute(att)
end
function c11511235.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c11511235.filterSP,1,nil,tp) end
	local g=eg:Filter(c11511235.filterSP,nil,tp)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetAttribute())
	local dg=Duel.GetMatchingGroup(c11511235.filterD,tp,0,LOCATION_MZONE,nil,tc:GetAttribute())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c11511235.operation(e,tp,eg,ep,ev,re,r,rp)
	local att=e:GetLabel()
	local dg=Duel.GetMatchingGroup(c11511235.filterD,tp,0,LOCATION_MZONE,nil,att)
	if dg:GetCount()>0 then 
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c11511235.filterxyz(c)
	return c:IsSetCard(0xffd) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c11511235.filterxyzOV(c)
	return c:IsSetCard(0xffd) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()==0 and not c:IsAttribute(ATTRIBUTE_FIRE) 
end
function c11511235.xyzop(e,tp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11511235.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c11511235.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ 
end
