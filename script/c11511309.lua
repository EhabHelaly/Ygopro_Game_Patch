-- Kairem Rho
function c11511309.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xffc),2,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c11511309.splimit)
	c:RegisterEffect(e1)
	--fusion summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(SUMMON_TYPE_FUSION)
	e2:SetCondition(c11511309.spcon)
	e2:SetOperation(c11511309.spop)
	c:RegisterEffect(e2)
	--Destroy (fusion summon)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c11511309.conSP)
	e3:SetLabel(SUMMON_TYPE_FUSION)
	e3:SetTarget(c11511309.target)
	e3:SetOperation(c11511309.operation)
	c:RegisterEffect(e3)
	-- ATK (Pendulum Summon)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetLabel(SUMMON_TYPE_PENDULUM)
	e4:SetCondition(c11511309.conSP)
	e4:SetValue(c11511309.value)
	c:RegisterEffect(e4)
	-- Scale (Pendulum Effect)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCondition(c11511309.conLV)
	e5:SetOperation(c11511309.operationLV)
	c:RegisterEffect(e5)

end
function c11511309.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c11511309.spfilter(c)
	return c:IsSetCard(0xffc) and c:IsCanBeFusionMaterial() and c:IsType(TYPE_MONSTER)
end
function c11511309.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return c:IsFacedown() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c11511309.spfilter,tp,LOCATION_GRAVE,0,2,nil)
end
function c11511309.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c11511309.spfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetFusionMaterial(g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c11511309.conSP(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==e:GetLabel()
end

function c11511309.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_ONFIELD,nil,POS_FACEDOWN)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c11511309.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_ONFIELD,nil,POS_FACEDOWN)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c11511309.value(e,c)
	local tp=c:GetControler()
	local tcl=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local tcr=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local total=0;
	if tcl and tcl:IsSetCard(0xffc) then total=total+tcl:GetLeftScale() end
	if tcr and tcr:IsSetCard(0xffc) then total=total+tcr:GetRightScale() end
	return total*100
end
function c11511309.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xffc) and c:IsType(TYPE_PENDULUM) and bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c11511309.conLV(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLeftScale()<11 and e:GetHandler():GetRightScale()<11 and eg:IsExists(c11511309.cfilter,1,nil)
end
function c11511309.operationLV(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or c:GetLeftScale()>=11 or c:GetRightScale()>=11 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e2)
end
